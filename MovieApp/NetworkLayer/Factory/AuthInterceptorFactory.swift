//
//  AuthInterceptorFactory.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

class AuthInterceptorFactory {
    static func getAuthInterceptorForAPIToken() -> RequestInterceptor {
        let authInterceptor = AuthInterceptor(token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMThlZjA3NzE5NTU5OTYyN2QwMWNmNTM0YjVjN2MwMiIsIm5iZiI6MTc1MTkwMDgzMS40MzUwMDAyLCJzdWIiOiI2ODZiZTI5ZmJhODFkMmQxNjJlZDU5ZjQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.iuXRCVlEgdb7X-y5cW6iBDjFrM0IU0wbI3QiE3UaTiw")
        return authInterceptor
    }
}
