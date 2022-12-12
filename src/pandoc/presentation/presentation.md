---
title: "PHP authentication bundles"
subtitle: "for Symfony"
author: "DIGIT PHP Support - Pol Dellaiera"
institute: "European Commission"
date: "December 2022"
documentclass: "beamer"
beamer: true
theme: "ec"
notes: true
toc: false
---

# Introduction

## ECPHP

> - Who we are
>   - Patrick
>   - Manos
>   - Pol
> - What we do

\note<1>{ How about starting with an introduction of the ECPHP team? }

\note<2>{ Patrick is managing the team and prioritizing the tasks to do }

\note<3>{ Emmanuel, the Patrick's backup }

\note<4>{ And then myself, I'm the developer of the team, while I'm mostly
assisting developers with their app developments and corporate libraries
development. I'm also experiment open source tools to ease the job of the
developers, such tools as Nix, LaTeX, Pandoc. }

## Repositories

> - code.europa.eu
> - github.com

\note<1>{ We have the brand new code.europa.eu which is the main repository }
\note<2>{ And we use Github as a backup repository }

# Authentication

> Authentication is the act of proving an assertion, such as the identity of a
> computer system user. In contrast with identification, the act of indicating a
> person or thing's identity, authentication is the process of verifying that
> identity.

\note{ Let's first start with a definition to make sure that everyone is on the
same wavelength. }

## Protocols

> - CAS
> - JWT

\note<1>{ When we think about authentication, we think about security,
protocols, single sign on. Protocols like...

- CAS for Central Authentication System which are redirection based protocols.
  They are using URL and redirections in your browser to authenticate users. CAS
  is used to authorize users to access an application, no users details are
  usually retrieved through it.
- JWT for Json Web Token protocols like OAuth, OpenID Connect, etc etc , used
  for authorization but also for exchanging information since using JWT is a
  good way to securely transmitting information between parties}

\note<2>{ These protocols can be used to secure web applications, and rest APIs.
}

\note<3>{Implementing the security in an application is something that might
quickly become cumbersome and time consuming, especially if the libraries to
implement the protocols are not available.}

\note<4>{Luckily for you, those libraries are already existing in the PHP world
and we published some of them in our team, in open-source.}

## Authentication at European Commission

![Alt text](src/pandoc/presentation/resources/loginbox.png)\

\note<1>{ I guess you all know this when it comes to authentication. }

\note<2>{ In the EC context, when it comes to authentication, we often think to
EU Login, the unique portal providing authentication for so many users,
consultants and employees at EC. }

\note<3>{ But have you ever think about the mechanism in-between your own
application hosted on your own domain and EU Login, hosted on another domain. }

\note<4>{ There are many ways to achieve that and today we are going to focus on
the CAS protocol. The EU Login platform implements multiple authentication
protocols and CAS is one of them. }

\note<5>{ Let's unravel the mysteries of the CAS protocol... don't be afraid! }

## CAS at European Commission

\only<1-3>{
\includegraphics{src/pandoc/presentation/resources/cas_flow_diagram.png} }
\only<3->{ \includegraphics{src/pandoc/presentation/resources/login.png} }

\note<1>{ Oops! Ok I guess you're afraid already! Sorry about that! }

\note<2>{ Here's the sequence diagram when you login through Eu Login using the
CAS Protocol. }

\note<3>{ But no worries, I made a simplified version of it... }

\note<4>{ In this sequence diagram, a user is trying to login onto a web app }

\note<5>{ At first the user open its browser, goes on the App and click the
login button or link }

\note<6>{ Somehow, the App detects that the user is not authenticated and
redirect the user to EU Login if so }

\note<7>{ Eu Login display the login form and the user submit its credentials }

\note<8>{ Eu Login redirects the user back to the application, appending a
special ticket parameter in the url, depending on the validity of its
credentials }

\note<9>{ The application validate the ticket parameter in the URL, if any }

\note<10>{ In case of valid credentials, the user is logged in or an error
message is displayed }

\note<11>{ As I said, this is an extremely simplified diagram and there are more
things that are done, but this is to give you an idea of what is going on when
you login onto an app. }

\note<12>{ We notice the interactions between the user and the App, the user and
EuLogin and the App with EuLogin. }

\note<13>{ If we only limit ourself to the CAS protocol for now, there are not a
lot of options for the developers... CAS Lib can be used with or without a
framework, DG Sante for example uses CAS Lib on a bare PHP app. }

\note<14>{ This is how CAS-Lib was born... but before going on to that subject,
let's have a look at what we have in store... }

# PHP

## PHP libraries / bundles / packages

![PHP Libraries](./src/pandoc/presentation/resources/php-libraries.png)\

\note<1>{ In this mindmap, you have a quick and global overview of the
authentication packages that we provides at ECPHP. }

\note<2>{ These packages are available from PHP 7 to 8 and we are slowly going
to deprecate support for PHP 7 }

\note<3>{The first one we did was CAS Lib. A library to facilitate the
communication with a standard CAS server. This is a library that I made on my
own and moved to ECPHP. The work on this library started around November 2019.
Initially called "PCAS", then renamed to "PSRCAS" and finally to "CAS Lib".

That package is a standard PHP library that can be used by any PHP application,
with or without a framework behind. It provides ways to authenticate a user
session using the CAS protocol.

The CAS Protocol is not complex, it just boils down to sending HTTP responses,
making requests, altering URLs, parsing JSON and XML, managing configuration...
But just that in PHP can be a problem... <sarcasm>anyway, what is not a problem
in PHP?</sarcasm>

- Sending HTTP redirections? Ok, but depending on where it is used, there might
  be plenty of different ways to send them.

- Altering URL? Seems to be the easiest part... erm wait, are we sure?

- Parsing JSON? Oh that\'s actually the easiest, there are core functions in PHP
  to encode and decode json... but bummer, `json\_decode` returns null for an
  invalid input... even though null is also a perfectly valid object for JSON to
  decode to! At the time of writing, it has been somehow fixed since PHP 7.3.
  Indeed, we can now throw an exception in case of issue while encoding or
  decoding a JSON string, but we have to add an optional flag while it should be
  the default behavior... Trust me, you're going to love PHP if you don't
  already.

- Parsing XML? Erm... Let me lol.

- Managing configuration? Seems easy at first sight.

In order to make it as standard as possible, it exclusively uses PSR interfaces,
hence the name PSR-CAS ! Don't worry, there's a slide about PSR. Therefore, CAS
Lib can be used in a Symfony project, Laravel project or any other framework.

A lot of effort into this library to make it consistent and well tested. }

\note<4>{ Then there is eCAS, a library decorating the CAS library and adding
compatibility with the customizations made by European Commission to the CAS
protocol. }

\note<5>{ There are only 2 libraries in ECPHP, the rest are Symfony bundle,
let's check them out... }

\note<6>{ CAS-Bundle which is a bundle letting any Symfony application
authenticate their users through the standard CAS protocol. Basically, this is
the glue code between Symfony and CAS-Lib. }

\note<7>{ Then there is the EU-Login-Bundle counterpart, which is the same as
CAS-Bundle, but for eCAS. }

\note<8>{ Then, API-GW-Authentication, which is basically a JWT authentication
with a mechanism to dynamically retrieve the JWKS keys from API Gateway. }

\note<9>{ And the last bundle, which was the most complicated to do: EU Login
API authentication which uses OpenID Connect protocol to authenticate users. }

\note<10>{ We made other bundles, but they are not relevant in the context of
authentication. }

## PHP FIG

::: columns

:::: column

> - PHP Framework Interoperability Group
> - PSR Standard Recommendation

::::

:::: column

> - PSR-0
> - PSR-3
> - PSR-4
> - PSR-6
> - PSR-7
> - PSR-11
> - PSR-12
> - PSR-18
> - PSR-20

::::

:::

\note<1>{ PHP FIG stands for PHP Framework Interoperability Group }

\note<2>{ While PSR stands for PSR Standard Recommendation

The idea behind the FIG group is for project representatives to talk about the
commonalities between our projects and find ways we can work together. If other
folks want to adopt what they’re doing they are welcome to do so, but that is
not the aim. Nobody in the group wants to tell you, as a programmer, how to
build your application.

They are responsible for the creation of the following PSRs }

\note<3>{In 2010, PSR-0, followed by PSR-4 in 2013 for providing the
autoloading... this is thanks to those PSR that we have composer! And without
Composer... we would be nowhere.}

\note<4>{PSR-3 for providing a logger mechanism interface}

\note<5>{In 2013, PSR-0 has been deprecated in favor of PSR-4}

\note<6>{PSR-6 for providing Caching interfaces}

\note<7>{PSR-7 for providing the Response and Request messages interface}

\note<8>{PSR-11 for providing the container interface}

\note<9>{PSR-12 for providing the coding standard rules}

\note<10>{PSR 18 for providing the HTTP client interface}

\note<11>{PSR-20 for providing a Clock interface... work in ongoing...}

\note<12>{There are many other PSRs, I invite you to check them out by yourself}

\note<13>{All these PSRs are mostly providing interfaces (except PSR12) and you
can use them anywhere. Thanks to the Liskov principle (1988) you are free to use
any contrib implementations as long as they are implementing the proper required
interface, you're good to go.}

## ECPHP

\only<1-3>{
  \includegraphics{./src/pandoc/presentation/resources/php-libraries-auth-0.png}
}
\only<4->{
  \includegraphics{./src/pandoc/presentation/resources/php-libraries-auth-1.png}
}

\note<1>{ Let's come back to the main subject of this talk, authentication and
summarize the protocols we made and which corresponding PHP library package can
be used. We have on the left the different authentication protocols that clients
are using and... }

\note<2>{On the right, we have the corresponding packages in PHP}

\note<3>{The CAS protocol in CAS-Lib and CAS-Bundle}

\note<4>{The ECAS protocol in ECAS and EU-Login-Bundle}

\note<5>{The Token authentication in API GW Authentication bundle, based on a
popular existing contrib bundle}

\note<6>{And the last one, The OpenID Connect authentication in EU Login API
Authentication bundle, based on an existing OpenID Connect contrib library.}

\note<7>{ Now you may wonder, is there a package for my own version of Symfony?
}

## Supported versions

![Versions](src/pandoc/presentation/resources/versions.png)\

\note<1>{ In this graphic, where only the CAS related packages are displayed,
you have some kind of matrix of supported versions we are maintaining. }

\note<2>{ Almost all the Symfony versions are covered, from 4.4 to 6.2 which are
not on this map. Symfony 6.2 has been released last week, on the 29 of November
by the way. If you're late to the party, it's still time to upgrade your app :)
}

\note<3>{ There are still two bundles in orange because I'm currently having
multiple issues with one of them, and I'm unable to make an short reproducer. }

\note<4>{ One of the issue has been reported and fixed in Symfony
(https://github.com/symfony/symfony/pull/47808) but the other one is still open.
If you want to help, let me know! }

\note<5>{ You may also notice that there is a major version jump for CAS Lib
between Symfony 6 and 6.1. }

\note<6>{ The reason is simple, CAS Lib has been completely rewritten recently,
getting rid of the ghosts from the past... }

\note<7>{ In ECPHP, we love the SOLID principles, do you know them?

The SOLID ideas are:

- The Single-responsibility principle: "There should never be more than one
  reason for a class to change.". In other words, every class should have only
  one responsibility.

- The Open–closed principle: "Software entities should be open for extension,
  but closed for modification."

- The Liskov substitution principle: "Functions that use pointers or references
  to base classes must be able to use objects of derived classes without knowing
  it.". In other words, use interfaces!

- The Interface segregation principle: "Clients should not be forced to depend
  upon interfaces that they do not use."

- The Dependency inversion principle: "Depend upon abstractions and not
  concretions."

If you really are interested, we can do a small session about it... but only if
you really are interested! :)

}

\note<8>{ CAS Lib has been completely rewritten for many reasons:

- The main CAS service was stateful. The CAS service was holding input data in
  some class properties. Basically the Symfony request was injected in the
  constructor. This forced us to tweak the Symfony container to do so and it
  reduce the flexibility of the library and introduces bugs at some point, see
  (https://github.com/ecphp/cas-bundle/issues/63)

- The CAS service was mutable, because of the aforementioned reason }

\note<9>{ There are still work to do in CAS Lib, like rewriting the tests using
PHPUnit. Indeed, currently we use PHPSpec, but we would like to get rid of it
everywhere for some reasons. It hasn't been done in version 2 because the amount
of tests is actually greater than the library itself and it would have been too
much at once. Also, rewriting the tests do not require a major version bump, so
it can be done at anytime. Willing to help? Contact me!}

\note<10>{ Right, I think we've said enough on the CAS protocol. What about the
rest? }

## Other protocols

- API GW Authentication > lexik/LexikJWTAuthenticationBundle
- EU Login API Authentication > facile-it/php-openid-client

\note<1>{ It is true that there won't be so much details about other bundles
because they basically rely on existing popular libraries that are working well
since years. }

\note<2>{ For API GW Authentication, it relies on LexikJWTAuthenticationBundle,
the only added value of the bundle is a custom KeyLoader which automatically
retrieve the JWKS keys automatically with a failsafe mechanism. }

\note<3>{ For EU Login API Authentication, we rely on
facile-it/php-openid-client which does the heavy lifting job for us.
Nevertheless, that bundle was the most complicated one to build. }

\note<4>{ One of the challenge we had during its creation was the ability to
generate fake valid token for the user so the application can be tested without
relying on the internet. }
