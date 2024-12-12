//
//  AccountTests.swift
//  QuizTests
//
//  Created by Vladimir Kurdiukov on 02.12.2024.
//

import XCTest

@testable import Quiz

class AccountTests: XCTestCase {
    var account: Account!
    var analyticsMock: AnalyticsMock!
    
    override func setUp() {
        self.analyticsMock = .init()
        self.account = .init(
            users: TestData.users,
            analytics: analyticsMock
        )
    }
    
    func testLoginPositive() {
        // given
        let login = TestData.correctLogin
        let password = TestData.correctPassword
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertTrue(result)
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "login_success")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func testLoginEmpty() {
        // given
        let login = ""
        let password = TestData.correctPassword
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "login_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func testLoginEmptyWhitespaces() {
        // given
        let login = " "
        let password = TestData.correctPassword
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "login_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func testLoginWrongRegister() {
        // given
        let login = TestData.correctLogin.capitalized
        let password = TestData.correctPassword
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "login_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func testUnknownLogin() {
        // given
        let login = TestData.incorrectLogin
        let password = TestData.correctPassword
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "login_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func testPasswordEmpty() {
        // given
        let login = TestData.correctLogin
        let password = ""
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "login_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func testPasswordEmptyWhitespaces() {
        // given
        let login = TestData.correctLogin
        let password = " "
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "login_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func testPasswordWrongRegister() {
        // given
        let login = TestData.correctLogin
        let password = TestData.correctPassword.capitalized
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
    }
    
    func testUnknownPassword() {
        // given
        let login = TestData.correctLogin
        let password = TestData.incorrectPassword
        // when
        let result = account.login(login: login, password: password)
        // then
        XCTAssertFalse(result)
    }
    
    
    func testRegisterPositive() {
        // given
        let login = TestData.correctRegisterLogin
        let password = TestData.correctRegisterPassword
        // when
        let result = account.register(login: login, password: password)
        // then
        XCTAssertEqual(result, .success(login))
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "register_success")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func test_RegisterUserExist() {
        // given
        let login = TestData.existUserLogin
        let password = TestData.correctRegisterPassword
        // when
        let result = account.register(login: login, password: password)
        // then
        XCTAssertEqual(result, .failure(.userExist))
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "register_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, ["reason":"userExist"])
    }
    
    func test_RegisterUserWhitespaces() {
        // given
        var login = " "
        let password = TestData.correctRegisterPassword
        // when
        var result = account.register(login: login, password: password)
        // then
        XCTAssertEqual(result, .failure(.whitespaces))
        // given
        login = "  "
        // when
        result = account.register(login: login, password: password)
        // then
        XCTAssertEqual(result, .failure(.whitespaces))
        // given
        login = "                   "
        // when
        result = account.register(login: login, password: password)
        // then
        XCTAssertEqual(result, .failure(.whitespaces))
        
        XCTAssertEqual(analyticsMock.sendWasCalled, 3)
        XCTAssertEqual(analyticsMock.sendParams.event, "register_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func test_RegisteUserMaxUserLength() {
        // given
        let login = TestData.loginOverMaxUserLength
        let password = TestData.correctRegisterPassword
        // when
        let result = account.register(login: login, password: password)
        // then
        XCTAssertEqual(result, .failure(.toLongUsername))
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "register_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
    func test_RegisterToShortPassword() {
        // given
        let login = TestData.correctRegisterLogin
        let password = TestData.tooShortPassword
        // when
        let result = account.register(login: login, password: password)
        // then
        XCTAssertEqual(result, .failure(.toShortPassword))
        XCTAssertEqual(analyticsMock.sendWasCalled, 1)
        XCTAssertEqual(analyticsMock.sendParams.event, "register_failed")
        XCTAssertEqual(analyticsMock.sendParams.params, [:])
    }
    
}

extension AccountTests {
    enum TestData {
        static var tooShortPassword = "qwerewq"
        static var loginOverMaxUserLength = "imnewuser"
        static var existUserLogin = correctLogin
        static var correctRegisterLogin = "inewuser"
        static var correctRegisterPassword = "somepass"
        static var correctLogin = "serge222"
        static var correctPassword = "qwerty1234"
        static var incorrectLogin = "somelogin222"
        static var incorrectPassword = "aq22222"
        static var users = [
           correctLogin : correctPassword,
           "sasha1337" : "djiu13j222"
        ]
    }
}
