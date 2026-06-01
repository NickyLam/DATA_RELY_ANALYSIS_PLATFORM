/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_pty
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.isbs_pty_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_pty
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pty_op purge;
drop table ${iol_schema}.isbs_pty_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pty_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pty where 0=1;

create table ${iol_schema}.isbs_pty_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pty where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pty_cl(
            inr -- 内部唯一id号
            ,extkey -- 客户号
            ,nam -- 客户名称
            ,ptytyp -- 客户类型
            ,accusr -- 用户帐户的id
            ,hbkaccflg -- housebank帐户标志
            ,hbkconflg -- housebank用户环境标志
            ,hbkinr -- 银行inr
            ,heqaccflg -- 总行帐户标志
            ,heqconflg -- 总行环境标志
            ,heqinr -- 总行inr
            ,prfctr -- 收益中心
            ,resusr -- 客户经理
            ,rskcls -- 风险等级
            ,rskcty -- 风险国家
            ,rsktxt -- 风险文本描述
            ,uil -- 传输的语言
            ,ver -- 版本号
            ,akkbra -- akk商业区域
            ,akkcom -- akk公司id
            ,akkreg -- akk地区编号
            ,lidcndflg -- 特别l/c情况
            ,lidmaxdur -- l/c最大期限日
            ,trdcndflg -- 特别交易情况
            ,trdtentot -- 汇票的最大期限日maximum
            ,trdtenini -- 最初汇票期限initial
            ,trdtenext -- 汇票的最大延期日maximum
            ,trdextnmb -- 汇票最大延期数
            ,badcndflg -- 特别ba情况
            ,badtenext -- ba最大期限日
            ,adrsta -- 地址状态
            ,seltyp -- 客户信贷利率
            ,buytyp -- 客户借贷利率
            ,sla -- 服务等级
            ,etgextkey -- 实体组
            ,nam1 -- 中文名称chinese
            ,juscod -- 技术监督局编号
            ,bilvvv -- 上浮比率
            ,cunqii -- 流动资金贷款利率档次
            ,idcode -- 身份证号码
            ,idtype -- 客户类型
            ,bchkeyinr -- 所属分行inr
            ,clscty -- 国家的信用等级credit
            ,procod -- 区域代码province
            ,trnman -- 交易主体
            ,speeco -- 特殊经济区域
            ,idtyp1 -- id类型1
            ,ratstm -- 
            ,banktyp -- 银行类型
            ,godcus -- 
            ,imginr -- 影像流水号
            ,bankno -- 人行行号
            ,drccod -- 所属直接参与机构
            ,bnkkey -- 联系地址外部关键字
            ,bnkref -- ECIF同业客户号
            ,risran -- 反洗钱等级
            ,imginr2 -- 新客户签约书
            ,risrantxt -- 反洗钱等级描述
            ,idcodlst -- 证件号码集合
            ,idtyplst -- 证件类型集合
            ,iscrb -- 跨境电商/跨境B2B
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pty_op(
            inr -- 内部唯一id号
            ,extkey -- 客户号
            ,nam -- 客户名称
            ,ptytyp -- 客户类型
            ,accusr -- 用户帐户的id
            ,hbkaccflg -- housebank帐户标志
            ,hbkconflg -- housebank用户环境标志
            ,hbkinr -- 银行inr
            ,heqaccflg -- 总行帐户标志
            ,heqconflg -- 总行环境标志
            ,heqinr -- 总行inr
            ,prfctr -- 收益中心
            ,resusr -- 客户经理
            ,rskcls -- 风险等级
            ,rskcty -- 风险国家
            ,rsktxt -- 风险文本描述
            ,uil -- 传输的语言
            ,ver -- 版本号
            ,akkbra -- akk商业区域
            ,akkcom -- akk公司id
            ,akkreg -- akk地区编号
            ,lidcndflg -- 特别l/c情况
            ,lidmaxdur -- l/c最大期限日
            ,trdcndflg -- 特别交易情况
            ,trdtentot -- 汇票的最大期限日maximum
            ,trdtenini -- 最初汇票期限initial
            ,trdtenext -- 汇票的最大延期日maximum
            ,trdextnmb -- 汇票最大延期数
            ,badcndflg -- 特别ba情况
            ,badtenext -- ba最大期限日
            ,adrsta -- 地址状态
            ,seltyp -- 客户信贷利率
            ,buytyp -- 客户借贷利率
            ,sla -- 服务等级
            ,etgextkey -- 实体组
            ,nam1 -- 中文名称chinese
            ,juscod -- 技术监督局编号
            ,bilvvv -- 上浮比率
            ,cunqii -- 流动资金贷款利率档次
            ,idcode -- 身份证号码
            ,idtype -- 客户类型
            ,bchkeyinr -- 所属分行inr
            ,clscty -- 国家的信用等级credit
            ,procod -- 区域代码province
            ,trnman -- 交易主体
            ,speeco -- 特殊经济区域
            ,idtyp1 -- id类型1
            ,ratstm -- 
            ,banktyp -- 银行类型
            ,godcus -- 
            ,imginr -- 影像流水号
            ,bankno -- 人行行号
            ,drccod -- 所属直接参与机构
            ,bnkkey -- 联系地址外部关键字
            ,bnkref -- ECIF同业客户号
            ,risran -- 反洗钱等级
            ,imginr2 -- 新客户签约书
            ,risrantxt -- 反洗钱等级描述
            ,idcodlst -- 证件号码集合
            ,idtyplst -- 证件类型集合
            ,iscrb -- 跨境电商/跨境B2B
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一id号
    ,nvl(n.extkey, o.extkey) as extkey -- 客户号
    ,nvl(n.nam, o.nam) as nam -- 客户名称
    ,nvl(n.ptytyp, o.ptytyp) as ptytyp -- 客户类型
    ,nvl(n.accusr, o.accusr) as accusr -- 用户帐户的id
    ,nvl(n.hbkaccflg, o.hbkaccflg) as hbkaccflg -- housebank帐户标志
    ,nvl(n.hbkconflg, o.hbkconflg) as hbkconflg -- housebank用户环境标志
    ,nvl(n.hbkinr, o.hbkinr) as hbkinr -- 银行inr
    ,nvl(n.heqaccflg, o.heqaccflg) as heqaccflg -- 总行帐户标志
    ,nvl(n.heqconflg, o.heqconflg) as heqconflg -- 总行环境标志
    ,nvl(n.heqinr, o.heqinr) as heqinr -- 总行inr
    ,nvl(n.prfctr, o.prfctr) as prfctr -- 收益中心
    ,nvl(n.resusr, o.resusr) as resusr -- 客户经理
    ,nvl(n.rskcls, o.rskcls) as rskcls -- 风险等级
    ,nvl(n.rskcty, o.rskcty) as rskcty -- 风险国家
    ,nvl(n.rsktxt, o.rsktxt) as rsktxt -- 风险文本描述
    ,nvl(n.uil, o.uil) as uil -- 传输的语言
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.akkbra, o.akkbra) as akkbra -- akk商业区域
    ,nvl(n.akkcom, o.akkcom) as akkcom -- akk公司id
    ,nvl(n.akkreg, o.akkreg) as akkreg -- akk地区编号
    ,nvl(n.lidcndflg, o.lidcndflg) as lidcndflg -- 特别l/c情况
    ,nvl(n.lidmaxdur, o.lidmaxdur) as lidmaxdur -- l/c最大期限日
    ,nvl(n.trdcndflg, o.trdcndflg) as trdcndflg -- 特别交易情况
    ,nvl(n.trdtentot, o.trdtentot) as trdtentot -- 汇票的最大期限日maximum
    ,nvl(n.trdtenini, o.trdtenini) as trdtenini -- 最初汇票期限initial
    ,nvl(n.trdtenext, o.trdtenext) as trdtenext -- 汇票的最大延期日maximum
    ,nvl(n.trdextnmb, o.trdextnmb) as trdextnmb -- 汇票最大延期数
    ,nvl(n.badcndflg, o.badcndflg) as badcndflg -- 特别ba情况
    ,nvl(n.badtenext, o.badtenext) as badtenext -- ba最大期限日
    ,nvl(n.adrsta, o.adrsta) as adrsta -- 地址状态
    ,nvl(n.seltyp, o.seltyp) as seltyp -- 客户信贷利率
    ,nvl(n.buytyp, o.buytyp) as buytyp -- 客户借贷利率
    ,nvl(n.sla, o.sla) as sla -- 服务等级
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 实体组
    ,nvl(n.nam1, o.nam1) as nam1 -- 中文名称chinese
    ,nvl(n.juscod, o.juscod) as juscod -- 技术监督局编号
    ,nvl(n.bilvvv, o.bilvvv) as bilvvv -- 上浮比率
    ,nvl(n.cunqii, o.cunqii) as cunqii -- 流动资金贷款利率档次
    ,nvl(n.idcode, o.idcode) as idcode -- 身份证号码
    ,nvl(n.idtype, o.idtype) as idtype -- 客户类型
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 所属分行inr
    ,nvl(n.clscty, o.clscty) as clscty -- 国家的信用等级credit
    ,nvl(n.procod, o.procod) as procod -- 区域代码province
    ,nvl(n.trnman, o.trnman) as trnman -- 交易主体
    ,nvl(n.speeco, o.speeco) as speeco -- 特殊经济区域
    ,nvl(n.idtyp1, o.idtyp1) as idtyp1 -- id类型1
    ,nvl(n.ratstm, o.ratstm) as ratstm -- 
    ,nvl(n.banktyp, o.banktyp) as banktyp -- 银行类型
    ,nvl(n.godcus, o.godcus) as godcus -- 
    ,nvl(n.imginr, o.imginr) as imginr -- 影像流水号
    ,nvl(n.bankno, o.bankno) as bankno -- 人行行号
    ,nvl(n.drccod, o.drccod) as drccod -- 所属直接参与机构
    ,nvl(n.bnkkey, o.bnkkey) as bnkkey -- 联系地址外部关键字
    ,nvl(n.bnkref, o.bnkref) as bnkref -- ECIF同业客户号
    ,nvl(n.risran, o.risran) as risran -- 反洗钱等级
    ,nvl(n.imginr2, o.imginr2) as imginr2 -- 新客户签约书
    ,nvl(n.risrantxt, o.risrantxt) as risrantxt -- 反洗钱等级描述
    ,nvl(n.idcodlst, o.idcodlst) as idcodlst -- 证件号码集合
    ,nvl(n.idtyplst, o.idtyplst) as idtyplst -- 证件类型集合
    ,nvl(n.iscrb, o.iscrb) as iscrb -- 跨境电商/跨境B2B
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_pty_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_pty where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.extkey <> n.extkey
        or o.nam <> n.nam
        or o.ptytyp <> n.ptytyp
        or o.accusr <> n.accusr
        or o.hbkaccflg <> n.hbkaccflg
        or o.hbkconflg <> n.hbkconflg
        or o.hbkinr <> n.hbkinr
        or o.heqaccflg <> n.heqaccflg
        or o.heqconflg <> n.heqconflg
        or o.heqinr <> n.heqinr
        or o.prfctr <> n.prfctr
        or o.resusr <> n.resusr
        or o.rskcls <> n.rskcls
        or o.rskcty <> n.rskcty
        or o.rsktxt <> n.rsktxt
        or o.uil <> n.uil
        or o.ver <> n.ver
        or o.akkbra <> n.akkbra
        or o.akkcom <> n.akkcom
        or o.akkreg <> n.akkreg
        or o.lidcndflg <> n.lidcndflg
        or o.lidmaxdur <> n.lidmaxdur
        or o.trdcndflg <> n.trdcndflg
        or o.trdtentot <> n.trdtentot
        or o.trdtenini <> n.trdtenini
        or o.trdtenext <> n.trdtenext
        or o.trdextnmb <> n.trdextnmb
        or o.badcndflg <> n.badcndflg
        or o.badtenext <> n.badtenext
        or o.adrsta <> n.adrsta
        or o.seltyp <> n.seltyp
        or o.buytyp <> n.buytyp
        or o.sla <> n.sla
        or o.etgextkey <> n.etgextkey
        or o.nam1 <> n.nam1
        or o.juscod <> n.juscod
        or o.bilvvv <> n.bilvvv
        or o.cunqii <> n.cunqii
        or o.idcode <> n.idcode
        or o.idtype <> n.idtype
        or o.bchkeyinr <> n.bchkeyinr
        or o.clscty <> n.clscty
        or o.procod <> n.procod
        or o.trnman <> n.trnman
        or o.speeco <> n.speeco
        or o.idtyp1 <> n.idtyp1
        or o.ratstm <> n.ratstm
        or o.banktyp <> n.banktyp
        or o.godcus <> n.godcus
        or o.imginr <> n.imginr
        or o.bankno <> n.bankno
        or o.drccod <> n.drccod
        or o.bnkkey <> n.bnkkey
        or o.bnkref <> n.bnkref
        or o.risran <> n.risran
        or o.imginr2 <> n.imginr2
        or o.risrantxt <> n.risrantxt
        or o.idcodlst <> n.idcodlst
        or o.idtyplst <> n.idtyplst
        or o.iscrb <> n.iscrb
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pty_cl(
            inr -- 内部唯一id号
            ,extkey -- 客户号
            ,nam -- 客户名称
            ,ptytyp -- 客户类型
            ,accusr -- 用户帐户的id
            ,hbkaccflg -- housebank帐户标志
            ,hbkconflg -- housebank用户环境标志
            ,hbkinr -- 银行inr
            ,heqaccflg -- 总行帐户标志
            ,heqconflg -- 总行环境标志
            ,heqinr -- 总行inr
            ,prfctr -- 收益中心
            ,resusr -- 客户经理
            ,rskcls -- 风险等级
            ,rskcty -- 风险国家
            ,rsktxt -- 风险文本描述
            ,uil -- 传输的语言
            ,ver -- 版本号
            ,akkbra -- akk商业区域
            ,akkcom -- akk公司id
            ,akkreg -- akk地区编号
            ,lidcndflg -- 特别l/c情况
            ,lidmaxdur -- l/c最大期限日
            ,trdcndflg -- 特别交易情况
            ,trdtentot -- 汇票的最大期限日maximum
            ,trdtenini -- 最初汇票期限initial
            ,trdtenext -- 汇票的最大延期日maximum
            ,trdextnmb -- 汇票最大延期数
            ,badcndflg -- 特别ba情况
            ,badtenext -- ba最大期限日
            ,adrsta -- 地址状态
            ,seltyp -- 客户信贷利率
            ,buytyp -- 客户借贷利率
            ,sla -- 服务等级
            ,etgextkey -- 实体组
            ,nam1 -- 中文名称chinese
            ,juscod -- 技术监督局编号
            ,bilvvv -- 上浮比率
            ,cunqii -- 流动资金贷款利率档次
            ,idcode -- 身份证号码
            ,idtype -- 客户类型
            ,bchkeyinr -- 所属分行inr
            ,clscty -- 国家的信用等级credit
            ,procod -- 区域代码province
            ,trnman -- 交易主体
            ,speeco -- 特殊经济区域
            ,idtyp1 -- id类型1
            ,ratstm -- 
            ,banktyp -- 银行类型
            ,godcus -- 
            ,imginr -- 影像流水号
            ,bankno -- 人行行号
            ,drccod -- 所属直接参与机构
            ,bnkkey -- 联系地址外部关键字
            ,bnkref -- ECIF同业客户号
            ,risran -- 反洗钱等级
            ,imginr2 -- 新客户签约书
            ,risrantxt -- 反洗钱等级描述
            ,idcodlst -- 证件号码集合
            ,idtyplst -- 证件类型集合
            ,iscrb -- 跨境电商/跨境B2B
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pty_op(
            inr -- 内部唯一id号
            ,extkey -- 客户号
            ,nam -- 客户名称
            ,ptytyp -- 客户类型
            ,accusr -- 用户帐户的id
            ,hbkaccflg -- housebank帐户标志
            ,hbkconflg -- housebank用户环境标志
            ,hbkinr -- 银行inr
            ,heqaccflg -- 总行帐户标志
            ,heqconflg -- 总行环境标志
            ,heqinr -- 总行inr
            ,prfctr -- 收益中心
            ,resusr -- 客户经理
            ,rskcls -- 风险等级
            ,rskcty -- 风险国家
            ,rsktxt -- 风险文本描述
            ,uil -- 传输的语言
            ,ver -- 版本号
            ,akkbra -- akk商业区域
            ,akkcom -- akk公司id
            ,akkreg -- akk地区编号
            ,lidcndflg -- 特别l/c情况
            ,lidmaxdur -- l/c最大期限日
            ,trdcndflg -- 特别交易情况
            ,trdtentot -- 汇票的最大期限日maximum
            ,trdtenini -- 最初汇票期限initial
            ,trdtenext -- 汇票的最大延期日maximum
            ,trdextnmb -- 汇票最大延期数
            ,badcndflg -- 特别ba情况
            ,badtenext -- ba最大期限日
            ,adrsta -- 地址状态
            ,seltyp -- 客户信贷利率
            ,buytyp -- 客户借贷利率
            ,sla -- 服务等级
            ,etgextkey -- 实体组
            ,nam1 -- 中文名称chinese
            ,juscod -- 技术监督局编号
            ,bilvvv -- 上浮比率
            ,cunqii -- 流动资金贷款利率档次
            ,idcode -- 身份证号码
            ,idtype -- 客户类型
            ,bchkeyinr -- 所属分行inr
            ,clscty -- 国家的信用等级credit
            ,procod -- 区域代码province
            ,trnman -- 交易主体
            ,speeco -- 特殊经济区域
            ,idtyp1 -- id类型1
            ,ratstm -- 
            ,banktyp -- 银行类型
            ,godcus -- 
            ,imginr -- 影像流水号
            ,bankno -- 人行行号
            ,drccod -- 所属直接参与机构
            ,bnkkey -- 联系地址外部关键字
            ,bnkref -- ECIF同业客户号
            ,risran -- 反洗钱等级
            ,imginr2 -- 新客户签约书
            ,risrantxt -- 反洗钱等级描述
            ,idcodlst -- 证件号码集合
            ,idtyplst -- 证件类型集合
            ,iscrb -- 跨境电商/跨境B2B
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一id号
    ,o.extkey -- 客户号
    ,o.nam -- 客户名称
    ,o.ptytyp -- 客户类型
    ,o.accusr -- 用户帐户的id
    ,o.hbkaccflg -- housebank帐户标志
    ,o.hbkconflg -- housebank用户环境标志
    ,o.hbkinr -- 银行inr
    ,o.heqaccflg -- 总行帐户标志
    ,o.heqconflg -- 总行环境标志
    ,o.heqinr -- 总行inr
    ,o.prfctr -- 收益中心
    ,o.resusr -- 客户经理
    ,o.rskcls -- 风险等级
    ,o.rskcty -- 风险国家
    ,o.rsktxt -- 风险文本描述
    ,o.uil -- 传输的语言
    ,o.ver -- 版本号
    ,o.akkbra -- akk商业区域
    ,o.akkcom -- akk公司id
    ,o.akkreg -- akk地区编号
    ,o.lidcndflg -- 特别l/c情况
    ,o.lidmaxdur -- l/c最大期限日
    ,o.trdcndflg -- 特别交易情况
    ,o.trdtentot -- 汇票的最大期限日maximum
    ,o.trdtenini -- 最初汇票期限initial
    ,o.trdtenext -- 汇票的最大延期日maximum
    ,o.trdextnmb -- 汇票最大延期数
    ,o.badcndflg -- 特别ba情况
    ,o.badtenext -- ba最大期限日
    ,o.adrsta -- 地址状态
    ,o.seltyp -- 客户信贷利率
    ,o.buytyp -- 客户借贷利率
    ,o.sla -- 服务等级
    ,o.etgextkey -- 实体组
    ,o.nam1 -- 中文名称chinese
    ,o.juscod -- 技术监督局编号
    ,o.bilvvv -- 上浮比率
    ,o.cunqii -- 流动资金贷款利率档次
    ,o.idcode -- 身份证号码
    ,o.idtype -- 客户类型
    ,o.bchkeyinr -- 所属分行inr
    ,o.clscty -- 国家的信用等级credit
    ,o.procod -- 区域代码province
    ,o.trnman -- 交易主体
    ,o.speeco -- 特殊经济区域
    ,o.idtyp1 -- id类型1
    ,o.ratstm -- 
    ,o.banktyp -- 银行类型
    ,o.godcus -- 
    ,o.imginr -- 影像流水号
    ,o.bankno -- 人行行号
    ,o.drccod -- 所属直接参与机构
    ,o.bnkkey -- 联系地址外部关键字
    ,o.bnkref -- ECIF同业客户号
    ,o.risran -- 反洗钱等级
    ,o.imginr2 -- 新客户签约书
    ,o.risrantxt -- 反洗钱等级描述
    ,o.idcodlst -- 证件号码集合
    ,o.idtyplst -- 证件类型集合
    ,o.iscrb -- 跨境电商/跨境B2B
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_pty_bk o
    left join ${iol_schema}.isbs_pty_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pty_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_pty;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_pty') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_pty drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_pty add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_pty exchange partition p_${batch_date} with table ${iol_schema}.isbs_pty_cl;
alter table ${iol_schema}.isbs_pty exchange partition p_20991231 with table ${iol_schema}.isbs_pty_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_pty to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pty_op purge;
drop table ${iol_schema}.isbs_pty_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_pty_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_pty',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
