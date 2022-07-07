%% ntnuthesis.cls - a LaTeX class for theses at NTNU
%%
%% CC-BY CoPCSE@NTNU, 2019
%%
%% Partly merged, partly based on, and partly a simplification of
%% various previous thesis templates by Simon McCallum, Ivar Farup,
%% Kjetil Ørbekk an others, by CoPCSE@NTNU.

%% IDENTIFICATION

\xdef\ntnuthesisdate{2021/12/20}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ntnuthesis}
 [\ntnuthesisdate\space
   CC-BY CoPCSE at NTNU 2019]


%% CLASS OPTIONS

% Package for some reason needed before the options
\RequirePackage{pdfpages}                   % including pdf files

% One or twosided paging
\newcommand{\paging}{twoside}
\DeclareOption{oneside}{
  \renewcommand{\paging}{oneside}
}

% Title Page
\DeclareOption{titlepage}{
    \AtBeginDocument{
        \begin{titlepage}
            \vbox{ }
            \vbox{ }
            \begin{center}
            % Upper part of the page
            \includegraphics[width=0.40\textwidth]{figures/NTNU_logo.png}\\[1cm]
            \textsc{\LARGE Department of Engineering Cybernetics}\\[1.5cm]
            \textsc{\large TTK4900}\\[0.5cm]
            \textsc{\large Cybernetics and robotics, Master's Thesis }\\[2.5cm]
            
            % Title
            { \Large \bfseries Reinforcement Learning for Fast, Map-Free Navigation \\[0.3cm] in Cluttered Environments Using Aerial Robots}\\[3cm]
            
            % Author
            \large
            Patrick Nitschke \\[0.2cm]
            {\large \today} \\[4cm]
            
            \large
            Supervisor: Prof. Dr. Kostas Alexis \\[0.2cm]
            Co-supervisers: Dinh Huan Nguyen, Mihir Kulkarni
            \vfill
            
            % Bottom of the page
            
            \end{center}
        \end{titlepage}
    }
}

% British
\newif\ifcapitalize
\DeclareOption{british}{
    \capitalizetrue
    \def\papername{Paper}
    \newcommand{\NTNU}{{N}orwegian {U}niversity of {S}cience and {T}echnology}
    \newcommand{\NTNUTrondheim}{{NTNU} in {T}rondheim}
    \newcommand{\NTNUGjoevik}{{NTNU} in {G}j\o{}vik}
    \newcommand{\NTNUAalesund}{{NTNU} in {\AA}lesund}
    \AtBeginDocument{
        \renewcommand{\lstlistingname}{Code listing}
        \renewcommand{\lstlistlistingname}{Code Listings}
        \crefname{listing}{Code listing}{Code listings}
        \crefname{paper}{Paper}{Papers}
        \addto\captionsbritish{
            \renewcommand{\contentsname}{Contents}
            \renewcommand{\listfigurename}{Figures}
            \renewcommand{\listtablename}{Tables}
            \renewcommand{\glossaryname}{Glossary}
            \renewcommand{\acronymname}{Acronyms}
        }
    }
}

\ProcessOptions

%% CLASS FILE LOADING

\LoadClass[a4paper,11pt,openright,\paging]{report}

%% PACKAGE LOADING

\RequirePackage[utf8]{inputenc}             % for special characters in input
\RequirePackage[T1]{fontenc}                % modern font encoding
\RequirePackage[charter, cal=cmcal]{mathdesign} % main font with math support
\RequirePackage{XCharter} % mathdesign with expert option disabled
\RequirePackage[scaled=.88]{berasans}       % sans serif font
\RequirePackage[scaled=.82]{DejaVuSansMono} % monospace font (for code)
\RequirePackage{listings}                   % code listings
\RequirePackage{etoolbox}                   % fixing list of listings spacing
\RequirePackage{babel}                      % language specifics
\RequirePackage{geometry}                   % page layout
\RequirePackage{enumitem}                   % customising list appearance
\RequirePackage{graphicx}                   % including figures
\RequirePackage{amsmath}                    % advanced math typesetting
\RequirePackage[                            % subfigures with captions within figures
    font=small,                             % and customisation of captions
    labelfont=bf,
    margin=\parindent
]{caption}
\RequirePackage[                           % and subfigures with captions within figures
    font=small,
    labelfont=bf,
    margin=\parindent
]{subcaption}
\RequirePackage{xcolor}                     % selecting text color
\RequirePackage{emptypage}                  % empty pages should be blank
\RequirePackage{csquotes}                   % recommended for biblatex
\RequirePackage[
    backend=biber,
    style=ieee,
    citestyle=numeric-comp,
    sorting=none,
    dashed=false
]{biblatex}                                 % for bibliography
\RequirePackage{csvsimple}                  % tables from csv files
\RequirePackage{booktabs}                   % better formatting of tables
\RequirePackage{gnuplottex}                 % for generating gnuplots on the fly
\RequirePackage{hyperref}                   % interactive cross references
\ifcapitalize
    \RequirePackage[capitalize,noabbrev]{cleveref}   % automatic cross references
\else
    \RequirePackage[noabbrev]{cleveref}
\fi
\RequirePackage[acronym]{glossaries}        % create a glossary and acronym list

%% CUSTOMISATION

% Page geometry and spacing (same for even and odd pages)
\geometry{left=2.6cm, right=2.6cm, top=4cm, bottom=4cm}
\frenchspacing

% Roman page numbers from the beginning of the document
\pagenumbering{roman}
\setcounter{page}{3}

% Switch to Arabic page numbering at the beginning of the first numbered chapter
\newif\iffirstchapter
\firstchaptertrue
\let\std@chapter\@chapter
\def\@chapter{
    \iffirstchapter
        \pagenumbering{arabic}
        \firstchapterfalse
    \fi
    \std@chapter
}

% Add unnumbered chapters to table of contents and headings
\let\std@schapter\@schapter
\def\@schapter#1{
    \std@schapter{#1}
    \addcontentsline{toc}{chapter}{#1}
    \def\ch@ptermark{#1}
}

% Dotted line and tighter vertical spacing for chapters in the table of contents
\def\l@chapter#1#2{\@dottedtocline{1}{0em}{1.5em}{\bf #1}{\bf #2}}

% Support for included papers (for compiled PhD theses)
\newcounter{paper}
\setcounter{paper}{0}
\def\thepaper{\Roman{paper}}
\newenvironment{paper}[2]
{
    \refstepcounter{paper}
    \def\include@papername{#1}
    \chapter*{\papername~\thepaper}
    \label[paper]{#2}
}{
    \cleardoublepage
    \includepdf[pages=-]{\include@papername}
}

% Allow for two versions of title and authors – full and short
\def\title#1{\def\@title{#1}\def\@shorttitle{#1}}
\def\shorttitle#1{\def\@shorttitle{#1}}
\def\author#1{\def\@author{#1}\def\@shortauthor{#1}}
\def\shortauthor#1{\def\@shortauthor{#1}}

% Headers and footers
\def\ps@ntnuheadings{%
    \let\@evenfoot\@empty
    \let\@oddfoot\@empty
    \def\@evenhead{\small\thepage\hfil\textit{\@shortauthor: \@shorttitle}}
    \def\@oddhead{\small\textit{\ch@ptermark}\hfil\thepage}
    \def\chaptermark##1{\def\ch@ptermark{\chaptername\ \thechapter: ##1}}
}
\pagestyle{ntnuheadings}

% Itemize and enumerate: tighter and with other symbols
\setlist[enumerate]{itemsep=0mm, topsep=5pt, partopsep=0mm, parsep=0mm}
\setlist[enumerate,1]{label=\arabic*., ref=\arabic*}
\setlist[enumerate,2]{label=\alph*., ref=\alph*}
\setlist[enumerate,3]{label=\roman*., ref=\roman*}
\setlist[itemize]{itemsep=0mm, topsep=5pt, partopsep=0mm, parsep=0mm}
\setlist[itemize,1]{label=$\bullet$}
\setlist[itemize,2]{label=$\circ$}
\setlist[itemize,3]{label=$-$}

% Make \fullcite show all authors irrespectively of maxcitenames
\preto\fullcite{\AtNextCite{\defcounter{maxnames}{99}}}

% Colour palette
\definecolor{thesisblue}{rgb}{.15, .15, .6}
\definecolor{thesisred}{rgb}{.4, .05, .15}
\definecolor{thesisgreen}{rgb}{.2, .3, .2}

% Formatting of code listings
\lstset{
    frame=single,
    basicstyle=\fontsize{11}{12}\ttfamily,
    keywordstyle=\color{thesisblue}\bfseries,
    stringstyle=\color{thesisred},
    commentstyle=\color{thesisgreen},
    identifierstyle=\color{black},
    numberstyle=\fontsize{9}{10}\selectfont,
    literate=
        {á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
        {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
        {à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
        {À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
        {ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
        {Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
        {â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
        {Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1
        {Ã}{{\~A}}1 {ã}{{\~a}}1 {Õ}{{\~O}}1 {õ}{{\~o}}1
        {œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
        {ű}{{\H{u}}}1 {Ű}{{\H{U}}}1 {ő}{{\H{o}}}1 {Ő}{{\H{O}}}1
        {ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
        {€}{{\euro}}1 {£}{{\pounds}}1 {«}{{\guillemotleft}}1
        {»}{{\guillemotright}}1 {ñ}{{\~n}}1 {Ñ}{{\~N}}1 {¿}{{?`}}1
}

% Ensure list of listings have additional spacing between chapters to match figures and tables
\pretocmd{\chapter}{\addtocontents{lol}{\protect\addvspace{10\p@}}}{}{}

% Settings for hyperref: setting all the links black for best printing. They will still be clickable in the PDF
\hypersetup{
    colorlinks=true,
    linkcolor=black,    % internal links (change box color with linkbordercolor)
    citecolor=black,    % links to bibliography
    filecolor=black,    % file links
    urlcolor=black      % external links
}

% Fix list of listings not rendering correctly for LaTeX generated by Sphinx, which uses literalblock instead of lstlisting
\let\l@literalblock\l@lstlisting

% Renew \lstlistoflistings command to avoid issues with incorrect headers for long lists
% Uses unnumbered chapter instead of a float like in the original source code.
% Based on source code for listings package https://ctan.uib.no/macros/latex/contrib/listings/listings.dtx line: 14635
\renewcommand*{\lstlistoflistings}{%
       \begingroup%
       \chapter*{\lstlistlistingname}%
       \parskip\z@\parindent\z@\parfillskip \z@ \@plus 1fil%
       \@starttoc{lol}%
       \endgroup%
       }%


%% Personal packages
\usepackage{setspace}
\setlength{\marginparwidth}{2cm} 
\usepackage[colorinlistoftodos,prependcaption,textsize=tiny]{todonotes}
\usepackage{algorithm}
\usepackage{algpseudocode}\usepackage{amsmath}
\usepackage{textcomp,gensymb}
\usepackage{mathtools}
\usepackage{svg}


%% Personal commands
\newcommand\numberthis{\addtocounter{equation}{1}\tag{\theequation}}

% Theory
\newcommand{\bx}{\boldsymbol{x}}
\newcommand{\bz}{\boldsymbol{z}}
\newcommand{\br}{\boldsymbol{r}}
\newcommand{\bw}{\boldsymbol{w}}

\newcommand{\bt}{\boldsymbol{\theta}}
\newcommand{\pbt}{p_{\boldsymbol{\theta}}}
\newcommand{\pbts}{p_{\boldsymbol{\theta}^*}}
\newcommand{\qbp}{q_{\boldsymbol{\phi}}}
\newcommand{\qbps}{q_{\boldsymbol{\phi}^*}}
\newcommand{\gbp}{g_{\boldsymbol{\phi}}}
\newcommand{\loss}{\mathcal{L}}
\newcommand{\E}{\mathbb{E}}

\newcommand{\hatE}{\hat{\mathbb{E}}_t}
\newcommand{\hatA}{\hat{A}_t}

\DeclarePairedDelimiterX{\infdivx}[2]{(}{)}{%
  #1\;\delimsize\|\;#2%
}
\DeclarePairedDelimiter{\norm}{\lVert}{\rVert}
\newcommand{\DKL}{D_{KL}\infdivx}

\newcommand{\qzgivex}{\qbp(\bz |\, \bx)}
\newcommand{\qzgived}{\qbp(\bz |\, \d)}
\newcommand{\pzgivex}{\pbt(\bz |\, \bx)}
\newcommand{\pxgivez}{\pbt(\bx |\, \bz)}
\newcommand{\pzgived}{\pbt(\bz |\, \d)}
\newcommand{\pdgivez}{\pbt(\d |\, \bz)}
\newcommand{\pdfgivez}{\pbt(\d^f |\, \bz)}
\newcommand{\pdfgivezt}{\pbt(\d^f_t |\, \bz_t)}
\newcommand{\actorpolicy}{\boldsymbol{\theta}_{\bt}(\a_t |\, \s_t, \, \z_t)}
\newcommand{\criticVF}{V_{\bt} (\s_t, \, \z_t)}

\newcommand{\Ewrtq}{\E_{\bx \sim \qzgivex}}

\newcommand{\nbt}{\nabla_{\boldsymbol{\theta}} \,}
\newcommand{\pibt}{\pi_{\boldsymbol{\theta}} (a \, | \, s)} % PPO actor
\newcommand{\pibtold}{\pi_{\boldsymbol{\theta}_\text{old}} (a \, | \, s)}
\newcommand{\Vbt}{V_{\boldsymbol{\theta}} (s)} % PPO critic


% Method
\newcommand{\pibtd}{\pi_{\boldsymbol{\theta}} (a \, | \, s, \, d)} % PPO actor
\newcommand{\pibtz}{\pi_{\boldsymbol{\theta}} (a \, | \, s, \, z)} % PPO actor




\newcommand{\p}{{\boldsymbol{p}}}
\renewcommand{\f}{{\boldsymbol{f}}}
\newcommand{\q}{{\boldsymbol{q}}}
\newcommand{\s}{{\boldsymbol{s}}}
\renewcommand{\d}{{\boldsymbol{d}}}
\newcommand{\z}{{\boldsymbol{z}}}
\newcommand{\bT}{{\boldsymbol{\Theta}}}
\newcommand{\bo}{{\boldsymbol{\omega}}}
\renewcommand{\v}{{\boldsymbol{v}}}
\renewcommand{\a}{{\boldsymbol{a}}}
\newcommand{\y}{{\boldsymbol{y}}}
\newcommand{\R}{\mathbb{R}}
\newcommand{\rew}[1]{R_{\text{#1}}}
\newcommand{\pen}[1]{P_{\text{#1}}}
\newcommand{\gain}[1]{K_{\text{#1}}}

\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator*{\argmin}{arg\,min}

% Results
\usepackage{array}
