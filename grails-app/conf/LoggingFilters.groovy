/**
* Copyright (c) 2012 Partners In Health.  All rights reserved.
* The use and distribution terms for this software are covered by the
* Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
* which can be found in the file epl-v10.html at the root of this distribution.
* By using this software in any fashion, you are agreeing to be bound by
* the terms of this license.
* You must not remove this notice, or any other, from this software.
**/

import org.slf4j.MDC
import util.ClickstreamUtil

class LoggingFilters {
	def filters = {
		all(controller:'*', action:'*') {
			before = {
				
				String sessionId = session?.user?.username//RequestContextHolder.getRequestAttributes()?.getSessionId()
                //String clickstreamAsString = ClickstreamUtil.getClickstreamAsString(session.clickstream)
				//log.info "SessionID " + sessionId
				MDC.put('username', session?.user?.username?:"Anonymous")
				MDC.put('location', session?.warehouse?.name?:"No location")
                //MDC.put('locale', session?.user?.locale?.toString()?:"No locale")
				MDC.put('ipAddress', request?.remoteAddr?:"No IP address")
				MDC.put('requestUri', request?.requestURI?:"No request URI")
                //MDC.put('requestUrl', request?.requestURL?:"No request URL")
				MDC.put('queryString', request?.queryString?:"No query string")
                //MDC.put('clickStream', clickstreamAsString?:"No clickstream")
			}
			after = {
			}
			afterView = {
				MDC.remove('username')
				MDC.remove('location')
                //MDC.remove('locale')
				MDC.remove('ipAddress')
				MDC.remove('requestUri')
				MDC.remove('queryString')
                //MDC.remove('clickStream')
			}
		}
	}
}