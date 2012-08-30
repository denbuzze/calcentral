/**
 * UserAuthorization.java
 * Copyright (c) 2012 The Regents of the University of California
 */
package edu.berkeley.calcentral.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import edu.berkeley.calcentral.daos.UserAuthorizationDao;

/**
 * Main service/helper used to check user authorization. Also used by
 * spring security for pageAuth checks.
 */
@Service
public class UserAuthorizationService implements UserDetailsService {

	@Autowired
	private UserAuthorizationDao userAuthorizationDao;

	public UserDetails loadUserByUsername(String uid) throws UsernameNotFoundException {
		return userAuthorizationDao.getUserDetails(uid);
	}

	public UserAuthorizationDao getUserAuthorizationDao() {
		return userAuthorizationDao;
	}

	public void setUserAuthorizationDao(UserAuthorizationDao userAuthorizationDao) {
		this.userAuthorizationDao = userAuthorizationDao;
	}

}