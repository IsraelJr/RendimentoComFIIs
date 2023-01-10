//
//  ListFii.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import SwiftSoup

class ListFii {
    enum SortFiis {
        case lowestPrice
        case highestPrice
        case highestDY
        case lowestDY
    }
    
    static var listFiis = [FIIModel.Fetch.FII]()
    /*
     [FIIModel.Fetch.FII.init(socialReason: "INTER TEVA INDICE DE TIJOLO FUNDO DE INVESTIMENTO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII INTER IT".trimmingCharacters(in: .whitespacesAndNewlines), code: "ITIT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LAVOURA FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LAVOURA".trimmingCharacters(in: .whitespacesAndNewlines), code: "LAVF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "AF INVEST CRI FDO. INV. IMOB - RECEBÍVEIS IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII AFHI CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "AFHI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "ALIANZA FOF FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ALIANZFF".trimmingCharacters(in: .whitespacesAndNewlines), code: "AFOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "ALIANZA MULTIOFFICES  - FDO. INV. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MULT OF1".trimmingCharacters(in: .whitespacesAndNewlines), code: "MTOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "ALIANZA TRUST RENDA IMOBILIARIA FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ALIANZA".trimmingCharacters(in: .whitespacesAndNewlines), code: "ALZR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "AUTONOMY EDIFÍCIOS CORPORATIVOS FUND. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII AUTONOMY".trimmingCharacters(in: .whitespacesAndNewlines), code: "AIEC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BANESTES RECEBÍVEIS IMOBILIÁRIOS FDO INV IMOB  FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BEES CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "BCRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BANRISUL NOVAS FRONTEIRAS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BANRISUL".trimmingCharacters(in: .whitespacesAndNewlines), code: "BNFS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BARZEL FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BARZEL".trimmingCharacters(in: .whitespacesAndNewlines), code: "BZEL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BASÍLICA PARTNERS LED CORPORATE FDO INV IMOB FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BASILICA".trimmingCharacters(in: .whitespacesAndNewlines), code: "BPLC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BB FDO INV IMOB PROGRESSIVO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BB PROGR".trimmingCharacters(in: .whitespacesAndNewlines), code: "BBFI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BB FUNDO DE FUNDOS - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BB FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "BBFO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BB PROGRESSIVO II FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BB PRGII".trimmingCharacters(in: .whitespacesAndNewlines), code: "BBPO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BB RECEBIVEIS IMOBILIARIOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BB RECIM".trimmingCharacters(in: .whitespacesAndNewlines), code: "BBIM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BB RENDA CORPORATIVA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BB CORP".trimmingCharacters(in: .whitespacesAndNewlines), code: "BBRC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BB RENDA DE PAPEIS IMOB II FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BB PAPII".trimmingCharacters(in: .whitespacesAndNewlines), code: "RDPD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BB RENDA DE PAPÉIS IMOBILIÁRIOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BB R PAP".trimmingCharacters(in: .whitespacesAndNewlines), code: "RNDP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BLUECAP RENDA LOG. FDO INV. IMOB. - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BLUECAP".trimmingCharacters(in: .whitespacesAndNewlines), code: "BLCP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BLUEMACAW CATUAÍ TRIPLE A FDO DE INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BLUE AAA".trimmingCharacters(in: .whitespacesAndNewlines), code: "BLCA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BLUEMACAW CRÉDITO IMOBILIÁRIO - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BLUE CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "BLMC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BLUEMACAW LOGÍSTICA FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BLUE LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "BLMG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BLUEMACAW OFFICE FUND II - FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BLUEMAC".trimmingCharacters(in: .whitespacesAndNewlines), code: "BLMO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BLUEMACAW RENDA + FOF FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BLUE FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "BLMR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BR PROPERTIES FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BR PROPE".trimmingCharacters(in: .whitespacesAndNewlines), code: "BROL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRADESCO CARTEIRA IMOBILIÁRIA ATIVA - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BCIA".trimmingCharacters(in: .whitespacesAndNewlines), code: "BCIA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRAZIL REAL ESTATE VICTORY FUND I - FDO. INV. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRE VIC".trimmingCharacters(in: .whitespacesAndNewlines), code: "BREV".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRAZIL REALTY FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRREALTY".trimmingCharacters(in: .whitespacesAndNewlines), code: "BZLI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRAZILIAN GRAVEYARD DEATH CARE FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DEA CARE".trimmingCharacters(in: .whitespacesAndNewlines), code: "CARE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRESCO LOGÍSTICA - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRESCO".trimmingCharacters(in: .whitespacesAndNewlines), code: "BRCO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRIO CRÉDITO ESTRUTURADO - FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRIO CRE".trimmingCharacters(in: .whitespacesAndNewlines), code: "BICE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRIO MULTIESTRATÉGIA FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRIO ME".trimmingCharacters(in: .whitespacesAndNewlines), code: "BIME".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRIO REAL ESTATE II - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRIO II".trimmingCharacters(in: .whitespacesAndNewlines), code: "BRIM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRIO REAL ESTATE III FDO DE INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRIO III".trimmingCharacters(in: .whitespacesAndNewlines), code: "BRIP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BRIO REAL ESTATE IV - FUNDO DE INVESTIMENTO IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRIO IV".trimmingCharacters(in: .whitespacesAndNewlines), code: "BIPD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BS2 ALLINVESTMENTS FDO DE INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BS2".trimmingCharacters(in: .whitespacesAndNewlines), code: "LLAO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BTG PACTUAL LOGISTICA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTLG".trimmingCharacters(in: .whitespacesAndNewlines), code: "BTLG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BTOWERS FII - FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTOWERS".trimmingCharacters(in: .whitespacesAndNewlines), code: "BTWR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BTSP I FDO. INVEST. IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTSP I".trimmingCharacters(in: .whitespacesAndNewlines), code: "BTSG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "BTSP II FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTSP II".trimmingCharacters(in: .whitespacesAndNewlines), code: "BTSI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CAIXA RIO BRAVO FDO DE FDOS INV IMOB II".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CX RBRA2".trimmingCharacters(in: .whitespacesAndNewlines), code: "CRFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CAIXA RIO BRAVO FUNDO DE FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CX RBRAV".trimmingCharacters(in: .whitespacesAndNewlines), code: "CXRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CANVAS CRI - FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CANVAS".trimmingCharacters(in: .whitespacesAndNewlines), code: "CCRF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CAPITÂNIA REIT FOF - FDO. INVEST. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CAP REIT".trimmingCharacters(in: .whitespacesAndNewlines), code: "CPFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CAPITANIA SECURITIES II FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CAPI SEC".trimmingCharacters(in: .whitespacesAndNewlines), code: "CPTS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CARTESIA RECEBÍVEIS IMOBILIÁRIOS - FUNDO DE INVEST".trimmingCharacters(in: .whitespacesAndNewlines), name: "CARTESIA FII".trimmingCharacters(in: .whitespacesAndNewlines), code: "CACR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CASTELLO BRANCO OFFICE PARK FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII C BRANCO".trimmingCharacters(in: .whitespacesAndNewlines), code: "CBOP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CF2 FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CF2".trimmingCharacters(in: .whitespacesAndNewlines), code: "CFHI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CIDADE JARDIM CONTINENAL TOWER FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CJCTOWER".trimmingCharacters(in: .whitespacesAndNewlines), code: "CJCT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CONSTANTINOPLA RECEBÍVEIS IMOBILIÁRIOS FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII FED HY".trimmingCharacters(in: .whitespacesAndNewlines), code: "CTNP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CORE METROPOLIS FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CORE MET".trimmingCharacters(in: .whitespacesAndNewlines), code: "CORM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CSHG IMOB. FOF - FDO INV. IMOB. - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CSHG FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CSHG LOGÍSTICA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CSHG LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGLG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CSHG PRIME OFFICES FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CSHGPRIM".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGPO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CSHG REAL ESTATE FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HG REAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGRE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CSHG RECEBÍVEIS IMOBILIÁRIOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CSHG CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CSHG RENDA URBANA - FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CSHG URB".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGRU".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CSHG RESIDENCIAL FDO DE INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CSHG RSD".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGRS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CVPAR FUNDO DE INVESTIMENTO IMOBILIÁRIO DE CRI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CVPAR".trimmingCharacters(in: .whitespacesAndNewlines), code: "CVPR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "CYRELA CRÉDITO - FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CYRELA".trimmingCharacters(in: .whitespacesAndNewlines), code: "CYCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "DEL MONTE AJAX FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DEL MONT".trimmingCharacters(in: .whitespacesAndNewlines), code: "DLMT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "DEVANT PROPERTIES FUNDO DE INVESTIMENTO IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DEVA PRO".trimmingCharacters(in: .whitespacesAndNewlines), code: "DPRO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "DEVANT RECEBÍVEIS IMOBILIÁRIOS FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DEVANT".trimmingCharacters(in: .whitespacesAndNewlines), code: "DEVA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "DIAMANTE FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DIAMANTE".trimmingCharacters(in: .whitespacesAndNewlines), code: "DAMT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "DOVEL FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DOVEL".trimmingCharacters(in: .whitespacesAndNewlines), code: "DOVL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "ENERGY RESORT FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ENERGY".trimmingCharacters(in: .whitespacesAndNewlines), code: "EGYR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "EQI RECEBÍVEIS IMOBILIÁRIOS FDO DE INV IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII EQI RECE".trimmingCharacters(in: .whitespacesAndNewlines), code: "EQIR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "ESTOQUE RESIDENCIAL E COMERCIAL RJ FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ESTOQ RJ".trimmingCharacters(in: .whitespacesAndNewlines), code: "ERCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "EUROPA 105 - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII EUROPA".trimmingCharacters(in: .whitespacesAndNewlines), code: "ERPA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "EVEN II KINEA FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII EVEN II".trimmingCharacters(in: .whitespacesAndNewlines), code: "KEVE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "EVEN PERMUTA KINEA FII - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII EV KINEA".trimmingCharacters(in: .whitespacesAndNewlines), code: "KINP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "EXES FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII EXES".trimmingCharacters(in: .whitespacesAndNewlines), code: "EXES".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FARIA LIMA CAPITAL RECEB. IMOB. I - FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII FL RECEB".trimmingCharacters(in: .whitespacesAndNewlines), code: "FLCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FATOR VERITA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII FATOR VE".trimmingCharacters(in: .whitespacesAndNewlines), code: "VRTA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO BRASÍLIO MACHADO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRASILIO".trimmingCharacters(in: .whitespacesAndNewlines), code: "BMII".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO DE INV IMOB LEBLON REALTY DESENVOLVIMENTO I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LEBLON".trimmingCharacters(in: .whitespacesAndNewlines), code: "LRDI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO DE INV IMOB MAUÁ CAPITAL HIGH YIELD - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MAUA HY".trimmingCharacters(in: .whitespacesAndNewlines), code: "MCHY".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO DE INV IMOB MAUA CAPITAL MPD DESENV RESID".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MAUA MPD".trimmingCharacters(in: .whitespacesAndNewlines), code: "MMPD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO DE INV IMOBILIÁRIO DE CRI INTEGRAL BREI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BREI".trimmingCharacters(in: .whitespacesAndNewlines), code: "IBCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO DE INVEST IMOB GUARDIAN MULTIESTRATÉGIA I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GUARD MU".trimmingCharacters(in: .whitespacesAndNewlines), code: "GAME".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - BTG PACTUAL CREDITO IMOBILIARIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTG CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "BTCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - BTG PACTUAL METROPOLIS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MTRS".trimmingCharacters(in: .whitespacesAndNewlines), code: "MTRS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII ANCAR IC".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ANCAR IC".trimmingCharacters(in: .whitespacesAndNewlines), code: "ANCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII ANHANGUERA EDUCACIONAL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ANH EDUC".trimmingCharacters(in: .whitespacesAndNewlines), code: "FAED".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII BM BRASCAN LAJES CORPORATIVAS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BMBRC LC".trimmingCharacters(in: .whitespacesAndNewlines), code: "BMLC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII BRLPROP".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRLPROP".trimmingCharacters(in: .whitespacesAndNewlines), code: "BPRP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII BTG PACTUAL CORP. OFFICE FUND".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BC FUND".trimmingCharacters(in: .whitespacesAndNewlines), code: "BRCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII BTG PACTUAL FUNDO DE CRI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII EXCELLEN".trimmingCharacters(in: .whitespacesAndNewlines), code: "FEXC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII BTG PACTUAL FUNDO DE FUNDOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BC FFII".trimmingCharacters(in: .whitespacesAndNewlines), code: "BCFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII CAMPUS FARIA LIMA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CAMPUSFL".trimmingCharacters(in: .whitespacesAndNewlines), code: "FCFL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII CENESP".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CENESP".trimmingCharacters(in: .whitespacesAndNewlines), code: "CNES".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII CEO CYRELA COMMERC. PROPERTIES".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CEO CCP".trimmingCharacters(in: .whitespacesAndNewlines), code: "CEOC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII EDIFÍCIO ALMIRANTE BARROSO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ALMIRANT".trimmingCharacters(in: .whitespacesAndNewlines), code: "FAMB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII EDIFÍCIO GALERIA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GALERIA".trimmingCharacters(in: .whitespacesAndNewlines), code: "EDGA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII ELDORADO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ELDORADO".trimmingCharacters(in: .whitespacesAndNewlines), code: "ELDO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII FLORIPA SHOPPING".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII FLORIPA".trimmingCharacters(in: .whitespacesAndNewlines), code: "FLRP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII HOSPITAL DA CRIANÇA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CRIANCA".trimmingCharacters(in: .whitespacesAndNewlines), code: "HCRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII HOSPITAL NOSSA SRA DE LOURDES".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LOURDES".trimmingCharacters(in: .whitespacesAndNewlines), code: "NSLU".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII HOTEL MAXINVEST".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HOTEL MX".trimmingCharacters(in: .whitespacesAndNewlines), code: "HTMX".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII MAX RETAIL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MAX RET".trimmingCharacters(in: .whitespacesAndNewlines), code: "MAXR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII NOVO HORIZONTE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NOVOHORI".trimmingCharacters(in: .whitespacesAndNewlines), code: "NVHO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII PARQUE D. PEDRO SHOPPING CENTER".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII D PEDRO".trimmingCharacters(in: .whitespacesAndNewlines), code: "PQDP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII PATEO BANDEIRANTES".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PTO BAND".trimmingCharacters(in: .whitespacesAndNewlines), code: "PATB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII RBR DESENVOLVIMENTO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBR DES".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII RBR RENDIMENTO HIGH GRADE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBRHGRAD".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII REC RECEBIVEIS IMOBILIARIOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII REC RECE".trimmingCharacters(in: .whitespacesAndNewlines), code: "RECR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII REC RENDA IMOBILIARIA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII REC REND".trimmingCharacters(in: .whitespacesAndNewlines), code: "RECT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII SHOPPING JARDIM SUL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SHOPJSUL".trimmingCharacters(in: .whitespacesAndNewlines), code: "JRDM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII SHOPPING PARQUE D. PEDRO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SHOP PDP".trimmingCharacters(in: .whitespacesAndNewlines), code: "SHDP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII SIA CORPORATE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SIA CORP".trimmingCharacters(in: .whitespacesAndNewlines), code: "SAIC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII TB OFFICE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TBOFFICE".trimmingCharacters(in: .whitespacesAndNewlines), code: "TBOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII TORRE ALMIRANTE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TORRE AL".trimmingCharacters(in: .whitespacesAndNewlines), code: "ALMI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII TORRE NORTE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TORRE NO".trimmingCharacters(in: .whitespacesAndNewlines), code: "TRNT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - FII VILA OLÍMPIA CORPORATE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OLIMPIA".trimmingCharacters(in: .whitespacesAndNewlines), code: "VLOL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - NCH EQI HIGH YIELD RECEBÍVEIS IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NCH EQI".trimmingCharacters(in: .whitespacesAndNewlines), code: "EQIN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - OURINVEST FUNDO DE FUNDOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OURI FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "OUFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - OURINVEST RE I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII WTC SP".trimmingCharacters(in: .whitespacesAndNewlines), code: "WTSP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - V2 PROPERTIES".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII V2 PROP".trimmingCharacters(in: .whitespacesAndNewlines), code: "VVPR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB - VBI LOGÍSTICO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VBI LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "LVBI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB BARIGUI RENDIMENTOS IMOB I FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BARIGUI".trimmingCharacters(in: .whitespacesAndNewlines), code: "BARI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB BR HOTEIS - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRHOTEIS".trimmingCharacters(in: .whitespacesAndNewlines), code: "BRHT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB BRASIL PLURAL ABSOLUTO FDO DE FUNDOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ABSOLUTO".trimmingCharacters(in: .whitespacesAndNewlines), code: "BPFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB BRASIL VAREJO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII B VAREJO".trimmingCharacters(in: .whitespacesAndNewlines), code: "BVAR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB BTG PACTUAL SHOPPINGS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTG SHOP".trimmingCharacters(in: .whitespacesAndNewlines), code: "BPML".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB BTG PACTUAL TERRAS AGRÍCOLAS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTG TAGR".trimmingCharacters(in: .whitespacesAndNewlines), code: "BTRA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB CAIXA CARTEIRA IMOBILIÁRIA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CAIXA CI".trimmingCharacters(in: .whitespacesAndNewlines), code: "CXCI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB CAIXA CEDAE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CX CEDAE".trimmingCharacters(in: .whitespacesAndNewlines), code: "CXCE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB CAIXA SEQ LOGÍSTICA RENDA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CX TRX".trimmingCharacters(in: .whitespacesAndNewlines), code: "CXTL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB CENTRO TEXTIL INTERNACIONAL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII C TEXTIL".trimmingCharacters(in: .whitespacesAndNewlines), code: "CTXT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB CJ - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CJ".trimmingCharacters(in: .whitespacesAndNewlines), code: "CJFI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB CONTINENTAL SQUARE FARIA LIMA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII S F LIMA".trimmingCharacters(in: .whitespacesAndNewlines), code: "FLMA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB EDIFÍCIO OURINVEST".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OURINVES".trimmingCharacters(in: .whitespacesAndNewlines), code: "EDFO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB EUROPAR".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII EUROPAR".trimmingCharacters(in: .whitespacesAndNewlines), code: "EURO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB GENERAL SEVERIANO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GEN SEV".trimmingCharacters(in: .whitespacesAndNewlines), code: "GESE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB GRAND PLAZA SHOPPING".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ABC IMOB".trimmingCharacters(in: .whitespacesAndNewlines), code: "ABCP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB GREEN TOWERS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII G TOWERS".trimmingCharacters(in: .whitespacesAndNewlines), code: "GTWR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB HABITAT I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HABITAT".trimmingCharacters(in: .whitespacesAndNewlines), code: "HBTT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB HOSPITAL UNIMED CAMPINA GRANDE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII UNIMED C".trimmingCharacters(in: .whitespacesAndNewlines), code: "HUCG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB HOSPITAL UNIMED SUL CAPIXABA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII H UNIMED".trimmingCharacters(in: .whitespacesAndNewlines), code: "HUSC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB INDUSTRIAL DO BRASIL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII INDL BR".trimmingCharacters(in: .whitespacesAndNewlines), code: "FIIB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB INFRA REAL ESTATE - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII INFRA RE".trimmingCharacters(in: .whitespacesAndNewlines), code: "FINF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB MEMORIAL OFFICE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MEMORIAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "FMOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB MERCANTIL DO BRASIL - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MERC BR".trimmingCharacters(in: .whitespacesAndNewlines), code: "MBRF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB MOGNO FUNDO DE FUNDOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MOGNO".trimmingCharacters(in: .whitespacesAndNewlines), code: "MGFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB MV9 - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MV9".trimmingCharacters(in: .whitespacesAndNewlines), code: "MVFI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB NESTPAR - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NESTPAR".trimmingCharacters(in: .whitespacesAndNewlines), code: "NPAR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB OURINVEST LOGÍSTICA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OURILOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "OULG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB PANAMBY".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PANAMBY".trimmingCharacters(in: .whitespacesAndNewlines), code: "PABY".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB PEDRA NEGRA RENDA IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII P NEGRA".trimmingCharacters(in: .whitespacesAndNewlines), code: "FPNG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB POLO ESTOQUE II - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII POLO II".trimmingCharacters(in: .whitespacesAndNewlines), code: "ESTQ".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB POLO SHOPPING INDAIATUBA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII POLO SHO".trimmingCharacters(in: .whitespacesAndNewlines), code: "VPSI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB PROJETO ÁGUA BRANCA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII A BRANCA".trimmingCharacters(in: .whitespacesAndNewlines), code: "FPAB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB RBR CREDITO IMOB ESTRUTURADO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBR PCRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRY".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB RBR PROPERTIES - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBR PROP".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB RIO BRAVO RENDA CORPORATIVA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIOB RC".trimmingCharacters(in: .whitespacesAndNewlines), code: "RCRB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB RIO BRAVO RENDA EDUCACIONAL - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIOB ED".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBED".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB RIO BRAVO RENDA VAREJO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIOB VA".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBVA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB RIO NEGRO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIONEGRO".trimmingCharacters(in: .whitespacesAndNewlines), code: "RNGO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB SÃO FERNANDO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SAO FER".trimmingCharacters(in: .whitespacesAndNewlines), code: "SFND".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB SC 401".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SC 401".trimmingCharacters(in: .whitespacesAndNewlines), code: "FISC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB SCP".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SCP".trimmingCharacters(in: .whitespacesAndNewlines), code: "SCPF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB SDI RIO BRAVO RENDA LOGISTICA - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SDI LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "SDIL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB SHOPPING PÁTIO HIGIENÓPOLIS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HIGIENOP".trimmingCharacters(in: .whitespacesAndNewlines), code: "SHPH".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB TG ATIVO REAL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TG ATIVO".trimmingCharacters(in: .whitespacesAndNewlines), code: "TGAR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB THE ONE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII THE ONE".trimmingCharacters(in: .whitespacesAndNewlines), code: "ONEF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB VEREDA - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VEREDA".trimmingCharacters(in: .whitespacesAndNewlines), code: "VERE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB VIA PARQUE SHOPPING - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII V PARQUE".trimmingCharacters(in: .whitespacesAndNewlines), code: "FVPQ".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB VIDA NOVA - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VIDANOVA".trimmingCharacters(in: .whitespacesAndNewlines), code: "FIVN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB VOTORANTIM LOGISTICA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VOT LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "VTLT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB VOTORANTIM SECURITIES".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VOT SEC".trimmingCharacters(in: .whitespacesAndNewlines), code: "VSEC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOB VOTORANTIM SHOPPING".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VOT SHOP".trimmingCharacters(in: .whitespacesAndNewlines), code: "VSHO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV IMOBILIÁRIO DE UNIDADES AUTÔNOMAS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII UNIDADES".trimmingCharacters(in: .whitespacesAndNewlines), code: "IDFI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV. IMOB. FOF INTEGRAL BREI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII FOF BREI".trimmingCharacters(in: .whitespacesAndNewlines), code: "IBFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV. IMOB. MOGNO REAL ESTATE IMPACT DEV. FUND".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MOGNO ID".trimmingCharacters(in: .whitespacesAndNewlines), code: "MGIM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV. IMOB. PLURAL RECEBIVEIS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PLURAL R".trimmingCharacters(in: .whitespacesAndNewlines), code: "PLCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV. IMOB. PLUS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PLUS".trimmingCharacters(in: .whitespacesAndNewlines), code: "VTPL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV. IMOB. REC LOGISTICA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII REC LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "RELG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV. IMOB. VBI CRI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VBI CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "CVBI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INV. MAUA CAPITAL RECEBIVEIS IMOB. - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MAUA".trimmingCharacters(in: .whitespacesAndNewlines), code: "MCCI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO INVEST IMOB GRAND PLAZA MALL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GRPLMALL".trimmingCharacters(in: .whitespacesAndNewlines), code: "FGPM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. A - TOWN".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII A TOWN".trimmingCharacters(in: .whitespacesAndNewlines), code: "ATWN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. ÁTRIO REIT RECEBÍVEIS IMOBILIÁRIOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ATRIO".trimmingCharacters(in: .whitespacesAndNewlines), code: "ARRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. BTG PACTUAL AGRO LOGÍSTICA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BTG AGRO".trimmingCharacters(in: .whitespacesAndNewlines), code: "BTAL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. CAIXA IMÓVEIS CORPORATIVOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CEF CORP".trimmingCharacters(in: .whitespacesAndNewlines), code: "CXCO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. HOUSI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HOUSI".trimmingCharacters(in: .whitespacesAndNewlines), code: "HOSI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. MOGNO HOTEIS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MOGNO HT".trimmingCharacters(in: .whitespacesAndNewlines), code: "MGHT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. REC FUNDO DE FUNDOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII REC FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "RECX".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INV. IMOB. VBI PRIME PROPERTIES".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VBI PRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "PVBI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INVEST. IMOB. DEVANT FOF IMOBILIÁRIOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DEVA FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "DVFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INVEST. IMOB. MOGNO CRI HIGH GRADE".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MOGNO HG".trimmingCharacters(in: .whitespacesAndNewlines), code: "MGCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INVEST. IMOB. RB CAPITAL I FUNDO DE FUNDOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RB CFOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "RFOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INVEST. IMOB. VOTORANTIM PATRIMONIAL V".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VOTP V".trimmingCharacters(in: .whitespacesAndNewlines), code: "VTPA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO. INVEST. IMOB. VOTORANTIM PATRIMONIAL XII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VOTP XII".trimmingCharacters(in: .whitespacesAndNewlines), code: "VTXI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FDO.INVEST. IMOB. MULTI RENDA URBANA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MULT REN".trimmingCharacters(in: .whitespacesAndNewlines), code: "HBRH".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FII IRIDIUM RECEBÍVEIS IMOBILIÁRIOS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII IRIDIUM".trimmingCharacters(in: .whitespacesAndNewlines), code: "IRDM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FRAM CAPITAL SBCLOG FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SBCLOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "SBCL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUND. INVEST. IMOB. SUCCESPAR VAREJO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII S VAREJO".trimmingCharacters(in: .whitespacesAndNewlines), code: "SPVJ".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE FDO INV IMOB KINEA FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KINEAFOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "KFOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVEST IMOB OURINVEST RENDA ESTRUTURADA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OU RENDA".trimmingCharacters(in: .whitespacesAndNewlines), code: "OURE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO - BLUE RECEBÍVEI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BLUE REC".trimmingCharacters(in: .whitespacesAndNewlines), code: "BLUR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO - DEVELOPMENT V1".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DEV ONE".trimmingCharacters(in: .whitespacesAndNewlines), code: "LKDV".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO - FII RBR DESENV".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBR III".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO ATHENA I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ATHENA I".trimmingCharacters(in: .whitespacesAndNewlines), code: "FATN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO BRL PROP II".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII BRLPROII".trimmingCharacters(in: .whitespacesAndNewlines), code: "BRLA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO CAIXA AGÊNCIAS".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII CAIXA AG".trimmingCharacters(in: .whitespacesAndNewlines), code: "CXAG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO HBC RENDA URBANA".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HBC REN".trimmingCharacters(in: .whitespacesAndNewlines), code: "HBCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO MINT EDUCACIONAL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MINT EDU".trimmingCharacters(in: .whitespacesAndNewlines), code: "MINT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO RIZA TERRAX".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIZA TX".trimmingCharacters(in: .whitespacesAndNewlines), code: "RZTR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "FUNDO DE INVESTIMENTO IMOBILIÁRIO ROOFTOP I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ROOFTOPI".trimmingCharacters(in: .whitespacesAndNewlines), code: "ROOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "G5 CIDADE NOVA FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TOUR V".trimmingCharacters(in: .whitespacesAndNewlines), code: "TCIN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GALAPAGOS FDO DE FDO - FII FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GALAPAGO".trimmingCharacters(in: .whitespacesAndNewlines), code: "GCFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GALAPAGOS RECEBÍVEIS IMOBILIÁRIOS - FDO. INV. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GLPG CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "GCRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GAZIT MALLS FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GAZIT".trimmingCharacters(in: .whitespacesAndNewlines), code: "GZIT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GENERAL SHOP E OUTLETS DO BRASIL FDO INV IMOB - FI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GENERAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "GSFI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GENERAL SHOPPING ATIVO E RENDA FUNDO DE INV, IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GEN SHOP".trimmingCharacters(in: .whitespacesAndNewlines), code: "FIGS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GGR COVEPI RENDA FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GGRCOVEP".trimmingCharacters(in: .whitespacesAndNewlines), code: "GGRC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GLP LOGÍSTICA FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GLP LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "GLPL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GRUPO RCFA FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GP RCFA".trimmingCharacters(in: .whitespacesAndNewlines), code: "RCFA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GTIS BRAZIL LOGISTICS FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GTIS LG".trimmingCharacters(in: .whitespacesAndNewlines), code: "GTLG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "GUARDIAN LOGISTICA FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII GUARDIAN".trimmingCharacters(in: .whitespacesAndNewlines), code: "GALG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HABITAT II - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HABIT II".trimmingCharacters(in: .whitespacesAndNewlines), code: "HABT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HAZ FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HAZ".trimmingCharacters(in: .whitespacesAndNewlines), code: "ATCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HECTARE CE - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HECTARE".trimmingCharacters(in: .whitespacesAndNewlines), code: "HCTR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HECTARE DESENV. STUDENT HOUSING - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HECT DES".trimmingCharacters(in: .whitespacesAndNewlines), code: "HCST".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HECTARE PROPERTIES FDO DE INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HECT PRP".trimmingCharacters(in: .whitespacesAndNewlines), code: "HCPR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HECTARE RECEBÍVEIS HIGH GRADE FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HECT CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "HCHG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE AAA FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HEDGEAAA".trimmingCharacters(in: .whitespacesAndNewlines), code: "HAAA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE ATRIUM SHOPPING SANTO ANDRE FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HATRIUM".trimmingCharacters(in: .whitespacesAndNewlines), code: "ATSA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE BRASIL SHOPPING FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HEDGEBS".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGBS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE LOGÍSTICA FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HEDGELOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "HLOG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE PALADIN DESIGN OFFICES FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HEDGE OF".trimmingCharacters(in: .whitespacesAndNewlines), code: "HDOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE REALTY DEVELOPMENT FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HREALTY".trimmingCharacters(in: .whitespacesAndNewlines), code: "HRDF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE RECEBIVEIS IMOB. FUNDO DE INVST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HEDGEREC".trimmingCharacters(in: .whitespacesAndNewlines), code: "HREC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE SEED FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HEDGE SD".trimmingCharacters(in: .whitespacesAndNewlines), code: "SEED".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE SHOPPING PARQUE DOM PEDRO FDO. DE INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HEDGEPDP".trimmingCharacters(in: .whitespacesAndNewlines), code: "HPDP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HEDGE TOP FOFII 3 FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HTOPFOF3".trimmingCharacters(in: .whitespacesAndNewlines), code: "HFOF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HGI CRÉDITOS IMOBILIÁRIOS FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HGI CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "HGIC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HSI ATIVOS FINANCEIROS FUNDO DE INVESTIMENTO IMOBI".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HSI CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "HSAF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HSI LOGÍSTICA FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HSI LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "HSLG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HSI MALL FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HSI MALL".trimmingCharacters(in: .whitespacesAndNewlines), code: "HSML".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HSI RENDA IMOB FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HSIRENDA".trimmingCharacters(in: .whitespacesAndNewlines), code: "HSRE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "HUSI FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII HUSI".trimmingCharacters(in: .whitespacesAndNewlines), code: "HUSI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "INTER TEVA INDICE DE PAPEL FUNDO DE INVESTIMENTO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII INTER IP".trimmingCharacters(in: .whitespacesAndNewlines), code: "ITIP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "INTER TÍTULOS IMOB. FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII INTER".trimmingCharacters(in: .whitespacesAndNewlines), code: "BICR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "IRIDIUM FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII IRIM".trimmingCharacters(in: .whitespacesAndNewlines), code: "IRIM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JACARANDÁ I FUNDO DE INVESTIMENTO IMOBILIÁRIO -FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JCDA I".trimmingCharacters(in: .whitespacesAndNewlines), code: "JCDA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JBFO FOF FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JBFO FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "JBFO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JFDCAM FUNDO DE INVESTIMENTO IMOBILIÁRIO FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JFDCAM".trimmingCharacters(in: .whitespacesAndNewlines), code: "VJFD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JFL LIVING FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JFL LIV".trimmingCharacters(in: .whitespacesAndNewlines), code: "JFLL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JPP ALLOCATION MOGNO - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JPPMOGNO".trimmingCharacters(in: .whitespacesAndNewlines), code: "JPPA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JPP CAPITAL FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JPP CAPI".trimmingCharacters(in: .whitespacesAndNewlines), code: "JPPC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JS ATIVOS FINANCEIROS FDO DE INV IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JS A FIN".trimmingCharacters(in: .whitespacesAndNewlines), code: "JSAF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JS REAL ESTATE MULTIGESTÃO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JS REAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "JSRE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "JT PREV FDO INV IMOB DESENVOLVIMENTO HABITACIONAL".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII JT PREV".trimmingCharacters(in: .whitespacesAndNewlines), code: "JTPR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KILIMA FIC FDO. IMOB. SUNO 30".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KILIMA".trimmingCharacters(in: .whitespacesAndNewlines), code: "KISU".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KILIMA VOLKANO RECEBÍVEIS IMOB FDO DE INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KIVO".trimmingCharacters(in: .whitespacesAndNewlines), code: "KIVO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KINEA CREDITAS FDO DE INV IMOBILIÁRIO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KINEA CR".trimmingCharacters(in: .whitespacesAndNewlines), code: "KCRE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KINEA HIGH YIELD CRI FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KINEA HY".trimmingCharacters(in: .whitespacesAndNewlines), code: "KNHY".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KINEA II REAL ESTATE EQUITY FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KII REAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "KNRE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KINEA ÍNDICES DE PREÇOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KINEA IP".trimmingCharacters(in: .whitespacesAndNewlines), code: "KNIP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KINEA RENDA IMOBILIÁRIA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KINEA".trimmingCharacters(in: .whitespacesAndNewlines), code: "KNRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KINEA RENDIMENTOS IMOBILIÁRIOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KINEA RI".trimmingCharacters(in: .whitespacesAndNewlines), code: "KNCR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "KINEA SECURITIES FDO. DE INV. IMOB. - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII KINEA SC".trimmingCharacters(in: .whitespacesAndNewlines), code: "KNSC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LAGO DA PEDRA - FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LAGO PDR".trimmingCharacters(in: .whitespacesAndNewlines), code: "LPLP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LATERES FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LATERES".trimmingCharacters(in: .whitespacesAndNewlines), code: "LATR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LEGATUS SHOPPINGS FDO. INV. IMOB. - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LEGATUS".trimmingCharacters(in: .whitespacesAndNewlines), code: "LASC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LESTE RIVA EQUITY PREFERENCIAL I FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LESTE PA".trimmingCharacters(in: .whitespacesAndNewlines), code: "LSPA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LOFT I - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LOFT I".trimmingCharacters(in: .whitespacesAndNewlines), code: "LOFT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LOFT II FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LOFT II".trimmingCharacters(in: .whitespacesAndNewlines), code: "LFTT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LOGCP INTER FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LGCP INT".trimmingCharacters(in: .whitespacesAndNewlines), code: "LGCP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "LUGGO FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LUGGO".trimmingCharacters(in: .whitespacesAndNewlines), code: "LUGG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MALLS BRASIL PLURAL FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MALLS BP".trimmingCharacters(in: .whitespacesAndNewlines), code: "MALL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MARESIAS FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MMVE OP".trimmingCharacters(in: .whitespacesAndNewlines), code: "MMVE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MAUÁ CAPITAL DESENV I FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MAUA DES".trimmingCharacters(in: .whitespacesAndNewlines), code: "MADS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MAUÁ CAPITAL HEDGE FUND - FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MAUA HF".trimmingCharacters(in: .whitespacesAndNewlines), code: "MCHF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MAXI RENDA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MAXI REN".trimmingCharacters(in: .whitespacesAndNewlines), code: "MXRF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MÉRITO DESENVOLVIMENTO IMOBILIÁRIO I FII - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MERITO I".trimmingCharacters(in: .whitespacesAndNewlines), code: "MFII".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MERITO FDO. AÇÕES IMOB. FII - FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MERITOFA".trimmingCharacters(in: .whitespacesAndNewlines), code: "MFAI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MOGNO LOGÍSTICA FUNDO DE INVEST. IMOBILIARIO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MOGNO LG".trimmingCharacters(in: .whitespacesAndNewlines), code: "MGLG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MOGNO PROPERTIES - FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MOGNO PR".trimmingCharacters(in: .whitespacesAndNewlines), code: "MGLC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MORE GESTÃO ATIVA DE RECEBÍVEIS FDO DE INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MORE ATV".trimmingCharacters(in: .whitespacesAndNewlines), code: "MATV".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MORE REAL ESTATE FOF FII FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MORE RE".trimmingCharacters(in: .whitespacesAndNewlines), code: "MORE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MORE RECEBÍVEIS IMOBILIÁRIOS FII FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MORE CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "MORC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MULTI PROPERTIES FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MULTPROP".trimmingCharacters(in: .whitespacesAndNewlines), code: "PRTS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MULTI SHOPPINGS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MULTSHOP".trimmingCharacters(in: .whitespacesAndNewlines), code: "SHOP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MULTIGESTÃO RENDA COMERCIAL FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MTGESTAO".trimmingCharacters(in: .whitespacesAndNewlines), code: "DRIT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "MULTIOFFICES 2 - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII MULT OF2".trimmingCharacters(in: .whitespacesAndNewlines), code: "MOFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "NAVI IMOBILIÁRIO TOTAL RETURN FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NAVI TOT".trimmingCharacters(in: .whitespacesAndNewlines), code: "NAVT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "NAVI RESIDENCIAL FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NAVI RSD".trimmingCharacters(in: .whitespacesAndNewlines), code: "APTO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "NEWPORT LOGÍSTICA FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NEWPORT".trimmingCharacters(in: .whitespacesAndNewlines), code: "NEWL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "NEWPORT RENDA URBANA FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NEWRU".trimmingCharacters(in: .whitespacesAndNewlines), code: "NEWU".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "NOVA I - FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII NOVA I".trimmingCharacters(in: .whitespacesAndNewlines), code: "NVIF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "OPPORTUNITY FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OPPORTUN".trimmingCharacters(in: .whitespacesAndNewlines), code: "FTCE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "OURINVEST JPP FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OURI JPP".trimmingCharacters(in: .whitespacesAndNewlines), code: "OUJP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "OURO VERDE DESENV IMOB I FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII OURO PRT".trimmingCharacters(in: .whitespacesAndNewlines), code: "ORPD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PANORAMA DESENVOLVIMENTO LOGÍSTICO FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PANORAMA".trimmingCharacters(in: .whitespacesAndNewlines), code: "PNDL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PANORAMA LAST MILE SBC FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII LASTMILE".trimmingCharacters(in: .whitespacesAndNewlines), code: "PNLN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PANORAMA PROPERTIES FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PAN PROP".trimmingCharacters(in: .whitespacesAndNewlines), code: "PNPR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PARKING PARTNERS FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PARK PAR".trimmingCharacters(in: .whitespacesAndNewlines), code: "VTVI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PARQUE ANHANGUERA FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PARQ ANH".trimmingCharacters(in: .whitespacesAndNewlines), code: "PQAG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PÁTRIA EDIFÍCIOS CORPORATIVOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PATRIA".trimmingCharacters(in: .whitespacesAndNewlines), code: "PATC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PÁTRIA LOGÍSTICA FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PATR LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "PATL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PERFORMA REAL ESTATE - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PERFORMA".trimmingCharacters(in: .whitespacesAndNewlines), code: "PEMA".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PERSONALE I FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PERSONAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "PRSN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PLURAL LOGÍSTICA FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PLURAL L".trimmingCharacters(in: .whitespacesAndNewlines), code: "PLOG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PLURAL RENDA URBANA FDO DE INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PLUR URB".trimmingCharacters(in: .whitespacesAndNewlines), code: "PURB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "POLO CREDITO IMOBILIARIO- FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII POLO CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "PORD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "POLO FDO INV IMOB - FII RECEBÍVEIS IMOBILIÁRIOS I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII POLO I".trimmingCharacters(in: .whitespacesAndNewlines), code: "PLRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PRAIA DO CASTELO FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PRAIA CS".trimmingCharacters(in: .whitespacesAndNewlines), code: "PCAS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PRAZO - FUNDO DE INVESTIMENTO IMOBILIÁRIO - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PRAZO".trimmingCharacters(in: .whitespacesAndNewlines), code: "PRZS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PRESIDENTE VARGAS FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII P VARGAS".trimmingCharacters(in: .whitespacesAndNewlines), code: "PRSV".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "PROLOGIS BRAZIL LOGISTICS VENTURE FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII PROLOGIS".trimmingCharacters(in: .whitespacesAndNewlines), code: "PBLV".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "QUASAR AGRO - FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII QUASAR A".trimmingCharacters(in: .whitespacesAndNewlines), code: "QAGR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "QUASAR CRÉDITO IMOBILIÁRIO FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII QUASAR C".trimmingCharacters(in: .whitespacesAndNewlines), code: "QAMI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "QUATA IMOB RECEBÍVEIS IMOB. - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII QUATA".trimmingCharacters(in: .whitespacesAndNewlines), code: "QIRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "R CAP 1810 FUNDO DE FUNDOS - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RCAP FOF".trimmingCharacters(in: .whitespacesAndNewlines), code: "XBXO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL DESENV RESID III FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBRESID3".trimmingCharacters(in: .whitespacesAndNewlines), code: "RSPD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL DESENV. RESID. II FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBRESID2".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBDS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL DESENV. RESIDENCIAL IV FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBRES IV".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBIR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL LOGÍSTICO FDO. INV. IMOB.ye".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBCAP LG".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBLG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL OFFICE INCOME FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII R INCOME".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBCO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL RECEBÍVEIS IMOB. FDO. INVEST. IMOB FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBCAP RI".trimmingCharacters(in: .whitespacesAndNewlines), code: "RRCI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL RENDA I FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RB CAP I".trimmingCharacters(in: .whitespacesAndNewlines), code: "FIIP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL RENDA II FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RB II".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL RENDA URBANA FDO. DE INVEST. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RB REN".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRU".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RB CAPITAL TFO SITUS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RB TFO".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBTS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RBR ALPHA MULTIESTRATÉGIA REAL ESTATE FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBRALPHA".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RBR DESENV COMERCIAL FEEDER FOF FDO INVEST IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBR FEED".trimmingCharacters(in: .whitespacesAndNewlines), code: "RCFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RBR LOG FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBR LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RBR PREMIUM RECEBÍVEIS IMOBILIÁRIOS FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBR PR".trimmingCharacters(in: .whitespacesAndNewlines), code: "RPRI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "REAG MULTI ATIVOS IMOBILIÁRIOS - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII REAGMULT".trimmingCharacters(in: .whitespacesAndNewlines), code: "RMAI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RIO BRAVO CREDITO IMOB HIGH GRADE FUND DE INVEST".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RBCRI IV".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBHG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RIO BRAVO CRÉDITO IMOB. HIGH YIELD FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RB YIELD".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBHY".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RIO BRAVO CRÉDITO IMOBILIÁRIO II FDO INV IMOB -FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIOBCRI2".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBVO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RIO BRAVO FUNDO DE FUNDOS DE INVESTIMENTO IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIOB FF".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RIO BRAVO RENDA RESIDENCIAL FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIOB RR".trimmingCharacters(in: .whitespacesAndNewlines), code: "RBRS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RIZA AKIN FDO. INV. IMOB. FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII RIZA AKN".trimmingCharacters(in: .whitespacesAndNewlines), code: "RZAK".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "RIZA ARCTIUM REAL ESTATE FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ARCTIUM".trimmingCharacters(in: .whitespacesAndNewlines), code: "ARCT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SANTANDER PAPEIS IMOB CDI FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SANT PAP".trimmingCharacters(in: .whitespacesAndNewlines), code: "SADI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SANTANDER RENDA DE ALUGUÉIS FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SANT REN".trimmingCharacters(in: .whitespacesAndNewlines), code: "SARE".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SÃO CARLOS RENDA IMOBILIÁRIA FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII S CARLOS".trimmingCharacters(in: .whitespacesAndNewlines), code: "SACL".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SAO DOMINGOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII DOMINGOS".trimmingCharacters(in: .whitespacesAndNewlines), code: "FISD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SÃO FRANCISCO 34 FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SAO FRAN".trimmingCharacters(in: .whitespacesAndNewlines), code: "SFRO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SEQUOIA III RENDA IMOBILIÁRIA - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SEQUOIA".trimmingCharacters(in: .whitespacesAndNewlines), code: "SEQR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SERRA VERDE FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SERRA VD".trimmingCharacters(in: .whitespacesAndNewlines), code: "SRVD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SHOPPING WEST PLAZA FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII W PLAZA".trimmingCharacters(in: .whitespacesAndNewlines), code: "WPLZ".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SIG CAPITAL RECEBÍVEIS PULVERIZADOS FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SIG CAP".trimmingCharacters(in: .whitespacesAndNewlines), code: "SIGR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SINGULARE FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII REIT RIV".trimmingCharacters(in: .whitespacesAndNewlines), code: "REIT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SJ AU LOGÍSTICA FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SJ AU".trimmingCharacters(in: .whitespacesAndNewlines), code: "SJAU".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SOLARIUM FII - FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SOLARIUM".trimmingCharacters(in: .whitespacesAndNewlines), code: "SOLR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SP DOWNTOWN FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SP DOWNT".trimmingCharacters(in: .whitespacesAndNewlines), code: "SPTW".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SPA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SPA".trimmingCharacters(in: .whitespacesAndNewlines), code: "SPAF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "STARX FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII STARX".trimmingCharacters(in: .whitespacesAndNewlines), code: "STRX".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SUNO FUNDO DE FUNDOS DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SUNOFOFI".trimmingCharacters(in: .whitespacesAndNewlines), code: "SNFF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "SUNO RECEBÍVEIS IMOBILIÁRIOS FDO DE INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII SUNO CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "SNCI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TELLUS DESENVOLVIMENTO LOGÍSTICO FDO. INVEST. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TELLUS".trimmingCharacters(in: .whitespacesAndNewlines), code: "TELD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TELLUS FUNDO DE FUNDOS - FII FDO DE INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TELF".trimmingCharacters(in: .whitespacesAndNewlines), code: "TELF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TELLUS PROPERTIES - FDO INV. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TEL PROP".trimmingCharacters(in: .whitespacesAndNewlines), code: "TEPP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TISHMAN SPEYER RENDA CORPORATIVA FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TISHMAN".trimmingCharacters(in: .whitespacesAndNewlines), code: "TSER".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TJK RENDA IMOBILIÁRIA FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TJK REND".trimmingCharacters(in: .whitespacesAndNewlines), code: "TJKB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TORDESILHAS EI FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TORDE EI".trimmingCharacters(in: .whitespacesAndNewlines), code: "TORD".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TRANSINC FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TRANSINC".trimmingCharacters(in: .whitespacesAndNewlines), code: "TSNC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TREECORP REAL ESTATE FDO INV IMOB - I".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TREECORP".trimmingCharacters(in: .whitespacesAndNewlines), code: "TCPF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TRX EDIFÍCIOS CORPORATIVOS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TRXE COR".trimmingCharacters(in: .whitespacesAndNewlines), code: "XTED".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TRX REAL ESTATE FDO. INV. IMOB. - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TRX REAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "TRXF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TRX REAL ESTATE II FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TRX R II".trimmingCharacters(in: .whitespacesAndNewlines), code: "TRXB".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "TS NEW MARGINAL - FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII TS NEW".trimmingCharacters(in: .whitespacesAndNewlines), code: "TSNM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "URCA PRIME RENDA FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII URCA REN".trimmingCharacters(in: .whitespacesAndNewlines), code: "URPR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VALORA CRI CDI FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VALREIII".trimmingCharacters(in: .whitespacesAndNewlines), code: "VGIR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VALORA CRI ÍNDICE DE PREÇO FDO INVEST. IMOB. FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VALORAIP".trimmingCharacters(in: .whitespacesAndNewlines), code: "VGIP".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VALORA HEDGE FUND FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VALOR HE".trimmingCharacters(in: .whitespacesAndNewlines), code: "VGHF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VBI CONSUMO ESSEN FDO. INVEST. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VBI CON".trimmingCharacters(in: .whitespacesAndNewlines), code: "EVBI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VBI REITS FOF - FDO. INV. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VBI REIT".trimmingCharacters(in: .whitespacesAndNewlines), code: "RVBI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VECTIS JUROS REAL FDO INV. IMOB. - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VECTIS".trimmingCharacters(in: .whitespacesAndNewlines), code: "VCJR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VECTIS RENDA RESIDENCIAL FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VECT REN".trimmingCharacters(in: .whitespacesAndNewlines), code: "VCRR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VECTOR QUELUZ ATIVOS IMOB FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VQ LAJES".trimmingCharacters(in: .whitespacesAndNewlines), code: "VLJS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VENUS - FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VENUS".trimmingCharacters(in: .whitespacesAndNewlines), code: "SALI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VERSALHES RECEBÍVEIS IMOBILIÁRIOS - FDO. INV. IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VERS CRI".trimmingCharacters(in: .whitespacesAndNewlines), code: "VSLH".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VIC DESENVOLVIMENTO VINTAGE 20/21 FUND INVEST IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VIC DES".trimmingCharacters(in: .whitespacesAndNewlines), code: "VIDS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VINCI IMÓVEIS URBANOS FDO. DE INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VINCI IU".trimmingCharacters(in: .whitespacesAndNewlines), code: "VIUR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VINCI INSTRUMENTOS FINANCEIROS FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VINCI IF".trimmingCharacters(in: .whitespacesAndNewlines), code: "VIFI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VINCI LOGÍSTICA FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VINCI LG".trimmingCharacters(in: .whitespacesAndNewlines), code: "VILG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VINCI OFFICES FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VINCI OF".trimmingCharacters(in: .whitespacesAndNewlines), code: "VINO".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VINCI SHOPPING CENTERS FDO INVEST IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VINCI SC".trimmingCharacters(in: .whitespacesAndNewlines), code: "VISC".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VOTORANTIM SECURITIES MASTER FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII V MASTER".trimmingCharacters(in: .whitespacesAndNewlines), code: "VOTS".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "VX XVI - FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII VX XVI".trimmingCharacters(in: .whitespacesAndNewlines), code: "VXXV".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "WHG REAL ESTATE FUNDO DE INVESTIMENTO IMOBILIÁRIO".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII WHG REAL".trimmingCharacters(in: .whitespacesAndNewlines), code: "WHGR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP CORPORATE MACAÉ FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP MACAE".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPCM".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP CREDITO IMOBILIÁRIO - FDO INV IMOB".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP CRED".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPCI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP HOTÉIS - FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP HOT".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPHT".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP INDUSTRIAL FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP INDL".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPIN".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP LOG FDO INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP LOG".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPLG".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP MALLS FDO INV IMOB FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP MALLS".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPML".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP PROPERTIES FDO. INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP PROP".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPPR".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "XP SELECTION FDO DE FUNDOS INV IMOB - FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII XP SELEC".trimmingCharacters(in: .whitespacesAndNewlines), code: "XPSF".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "YUCA FDO INV. IMOB.".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII YUCA".trimmingCharacters(in: .whitespacesAndNewlines), code: "YUFI".trimmingCharacters(in: .whitespacesAndNewlines)),
     FIIModel.Fetch.FII.init(socialReason: "ZION CAPITAL FUNDO DE INVESTIMENTO IMOBILIÁRIO FII".trimmingCharacters(in: .whitespacesAndNewlines), name: "FII ZION".trimmingCharacters(in: .whitespacesAndNewlines), code: "ZIFI".trimmingCharacters(in: .whitespacesAndNewlines)),]
     */
    
    static func saveLocal() {
        var listCodes = [String]()
        ListFii.listFiis.forEach({
            if let _ = $0.code {
                listCodes.append($0.code)
                let monthCurrent = $0.earnings?.first(where: {$0.key.elementsEqual(Month.current.description().0)})
                UserDefaults.standard.set($0.code, forKey: $0.code)
                UserDefaults.standard.set($0.socialReason, forKey: "\($0.code!)_social")
                UserDefaults.standard.set($0.name, forKey: "\($0.code!)_name")
                UserDefaults.standard.set($0.price, forKey: "\($0.code!)_price")
                UserDefaults.standard.set($0.segment, forKey: "\($0.code!)_segment")
                UserDefaults.standard.set(monthCurrent?.value["earnings"], forKey: "\($0.code!)_currentEarnings")
                UserDefaults.standard.set(monthCurrent?.value["price_date_with"], forKey: "\($0.code!)_currentPrice_date_with")
                UserDefaults.standard.set(monthCurrent?.value["date_with"], forKey: "\($0.code!)_currentDate_with")
                UserDefaults.standard.set(monthCurrent?.value["payment_date"], forKey: "\($0.code!)_currentPayment_date")
                UserDefaults.standard.set($0.dailyLiquidity, forKey: "\($0.code!)_dailyLiquidity")
                UserDefaults.standard.set($0.dividendYield, forKey: "\($0.code!)_dividendYield")
                UserDefaults.standard.set($0.netWorth, forKey: "\($0.code!)_netWorth")
                UserDefaults.standard.set($0.equityValue, forKey: "\($0.code!)_equityValue")
                UserDefaults.standard.set($0.numberShares, forKey: "\($0.code!)_numberShares")
                UserDefaults.standard.set($0.profitabilityMonth, forKey: "\($0.code!)_profitabilityMonth")
                UserDefaults.standard.set($0.phone, forKey: "\($0.code!)_phone")
                UserDefaults.standard.set($0.site, forKey: "\($0.code!)_site")
            }
            
        })
        UserDefaults.standard.set(listCodes, forKey: "listFiis")
    }
    
    
    static func getListLocal() {
        if ListFii.listFiis.isEmpty {
            var result = [FIIModel.Fetch.FII]()
            let listCodes = UserDefaults.standard.stringArray(forKey: "listFiis") ?? [String]()
            listCodes.forEach({
                let monthCurrent = [Util.currentYear:[Month.current.description().0:["earnings":UserDefaults.standard.string(forKey: "\($0)_currentEarnings"),
                                                 "price_date_with":UserDefaults.standard.string(forKey: "\($0)_currentPrice_date_with"),
                                                 "date_with":UserDefaults.standard.string(forKey: "\($0)_currentDate_with"),
                                                 "payment_date":UserDefaults.standard.string(forKey: "\($0)_currentPayment_date")]]]
                
                result.append(.init(socialReason:           UserDefaults.standard.string(forKey: "\($0)_social")
                                    , name:                 UserDefaults.standard.string(forKey: "\($0)_name")
                                    , code:                 UserDefaults.standard.string(forKey: $0)
                                    , segment:              UserDefaults.standard.string(forKey: "\($0)_segment")
                                    , price:                UserDefaults.standard.string(forKey: "\($0)_price")
                                    , earnings:             monthCurrent
                                    , dailyLiquidity:       UserDefaults.standard.string(forKey: "\($0)_dailyLiquidity")
                                    , dividendYield:        UserDefaults.standard.string(forKey: "\($0)_dividendYield")
                                    , netWorth:             UserDefaults.standard.string(forKey: "\($0)_netWorth")
                                    , equityValue:          UserDefaults.standard.string(forKey: "\($0)_equityValue")
                                    , numberShares:         UserDefaults.standard.integer(forKey: "\($0)_numberShares")
                                    , profitabilityMonth:   UserDefaults.standard.string(forKey: "\($0)_profitabilityMonth")
                                    , phone:                UserDefaults.standard.string(forKey: "\($0)_phone")
                                    , site:                 UserDefaults.standard.string(forKey: "\($0)_site")
                                   ))
            })
            
            ListFii.listFiis = result
            x()
            
        }
    }
    
    
    static func allFiis() -> [FIIModel.Fetch.FII] {
        listFiis.sort{($0.code) < ($1.code)}
        return listFiis
    }
    
    static func sortBySegment(segment: FiiSegment) -> [FIIModel.Fetch.FII] {
        if segment.rawValue.elementsEqual(FiiSegment.all.rawValue) {
            return listFiis
        }
        var temp = [FIIModel.Fetch.FII]()
        listFiis.forEach({
            if $0.segment!.elementsEqual(segment.rawValue) {
                temp.append($0)
            }
        })
        temp.sort{($0.code) < ($1.code)}
        return temp
    }
    
    static func tenRandomFiis() -> [FIIModel.Fetch.FII] {
        var tenFiis = [FIIModel.Fetch.FII]()
        if !listFiis.isEmpty {
            for _ in 0..<10 {
                tenFiis.append(listFiis[Int(arc4random_uniform(UInt32(listFiis.count)))])
            }
        }
        tenFiis.sort{($0.code) < ($1.code)}
        return tenFiis
    }
    
    static func tenPrices(typeSort: SortFiis) -> [FIIModel.Fetch.FII] {
        var tenFiis = [FIIModel.Fetch.FII]()
        var temp = listFiis
        let temp2 = listFiis
        for i in 0..<temp.count {
            temp[i].price = temp[i].price?.replacingOccurrences(of: "R$ ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
        }
        switch typeSort {
        case .highestPrice:
            temp.sort{(Double($0.price!)!) > (Double($1.price!)!)}
        case .lowestPrice:
            temp.sort{(Double($0.price!)!) < (Double($1.price!)!)}
        default:
            break
        }
        for i in 0..<10 {
            temp2.forEach({
                if $0.code == temp[i].code {
                    tenFiis.append($0)
                }
            })
        }
        return tenFiis
    }
    
    static func tenDy(typeSort: SortFiis) -> [FIIModel.Fetch.FII] {
        var tenFiis = [FIIModel.Fetch.FII]()
        var temp = listFiis
        let temp2 = listFiis
        for i in 0..<temp.count {
            temp[i].dividendYield = temp[i].dividendYield?.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: ",", with: "")
        }
        switch typeSort {
        case .highestDY:
            temp.sort{(Double($0.dividendYield ?? "0.0") ?? 0.0) > (Double($1.dividendYield ?? "0.0") ?? 0.0)}
        case .lowestDY:
            temp.sort{(Double($0.dividendYield ?? "0.0") ?? 0.0) < (Double($1.dividendYield ?? "0.0") ?? 0.0)}
        default:
            break
        }
        for i in 0..<10 {
            temp2.forEach({ fii in
                if fii.code == temp[i].code, (quoteList.first(where: {$0.code.elementsEqual(fii.code)}) != nil) {
                    tenFiis.append(fii)
                }
            })
        }
        
        return tenFiis
    }
    
    static func x() {
        var lisTString = [String]()
        listFiis.forEach({ fii in
            if !lisTString.contains(fii.segment!) {
                lisTString.append(fii.segment!)
            }
        })
        //        lisTString.forEach({print($0)})
    }
    
    static func getReport(_ code: String, result:@escaping(responseHandlerArray)) {
        var urlSite = ""
        switch code {
        case "URPR11":
            urlSite = "https://www.urcacp.com.br/ri-urpr11"
            
        case "HCTR11":
            urlSite = "https://www.hectarecapital.com.br/hctr11"
            
        default:
            break
        }
        if urlSite.isEmpty {
            result([""])
            return
        }
        let url = URL(string: urlSite)!
        let taskUm = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                result([""])
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                result([ListFii.extractHref(code, doc)])
                
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                result([""])
            } catch {
                print("erro")
                result([""])
            }
        }
        taskUm.resume()
    }
    
    private static func extractHref(_ code: String, _ doc: Document) -> String {
        var href = ""
        do {
            switch code {
            case "URPR11":
                href = try doc.getElementById("comp-kh0ky7ji")?.getElementsByClass("_2UgQw").last()?.select("a").attr("href") ?? ""
                
            case "HCTR11":
                href = try doc.getElementById("comp-jwtriiao")?.select("a").attr("href") ?? ""
                
            default:
                break
            }
        } catch {
            print("erro")
        }
        return href
    }
    
    static func sortByLetters(text: String) -> [FIIModel.Fetch.FII] {
        var tenFiis = [FIIModel.Fetch.FII]()
        if !listFiis.isEmpty {
            tenFiis = listFiis.filter({$0.code.prefix(text.count).elementsEqual(text)})
        }
        tenFiis.sort{($0.code) < ($1.code)}
        return tenFiis
    }
}
