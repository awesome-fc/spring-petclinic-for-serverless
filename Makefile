include .env
export $(shell sed 's/=.*//' .env)

publish_name := Spring-PetClinic
dist := ./dist/$(publish_name)

OSS_BUCKET ?= fun-pkg-hk-1
PROFILE ?= fc-demo

clean:
	rm -rf dist/*
	mvn clean

prepare:
	mkdir -p $(dist)
	
package: prepare
	mvn package -Dmaven.test.skip=true
	zip -r $(dist)/code.zip bootstrap target/spring-petclinic-*.jar 
	fun package --oss-bucket $(OSS_BUCKET)

build: package
	cp -r doc/*.md $(dist)
	sed -e 's/CodeUri:.*/CodeUri: oss:\/\/%bucket%\/%templateName%\/code.zip/g' template.yml > $(dist)/template.yml

deploy: build
	fun deploy --use-ros --stack-name spring-test -y

undeploy:
	$(eval StackId=$(shell aliyun --profile $(PROFILE) ros ListStacks --StackName.1 spring-test | jq -r '.Stacks[0].StackId'))
	aliyun --profile $(PROFILE) ros DeleteStack --StackId $(StackId)

publish: build
	cd $(dist); fcat publish

publish-prod: build
	cd $(dist); fcat publish -p

unpublish:
	fcat delete $(publish_name)