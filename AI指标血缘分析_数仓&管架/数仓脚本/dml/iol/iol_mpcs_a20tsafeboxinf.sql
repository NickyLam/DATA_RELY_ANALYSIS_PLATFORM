/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a20tsafeboxinf
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
create table ${iol_schema}.mpcs_a20tsafeboxinf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a20tsafeboxinf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a20tsafeboxinf_op purge;
drop table ${iol_schema}.mpcs_a20tsafeboxinf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a20tsafeboxinf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a20tsafeboxinf where 0=1;

create table ${iol_schema}.mpcs_a20tsafeboxinf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a20tsafeboxinf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a20tsafeboxinf_cl(
            mainseq -- 中台流水
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fnttrncd -- 交易码
            ,safebox -- 保管箱编号
            ,custtype -- 客户类型
            ,custnm -- 客户名称
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,payacct -- 付款账号
            ,subseqno -- 子账户
            ,payname -- 付款人名称
            ,payprodtype -- 付款方产品类型
            ,incoacct -- 收款账号
            ,incosubseqno -- 收款方子账户
            ,inconame -- 收款人名称
            ,incoprodtype -- 收款方产品类型
            ,deposit -- 押金
            ,ccy -- 币种
            ,doctype -- 凭证类型
            ,docno -- 凭证号码
            ,draftdate -- 凭证到日期
            ,fundsource -- 资金来源:1-现金；2-客户转账；3-内部户转账
            ,opnrs_9_elmnt -- 开箱人9要素
            ,opnrs_20_elmnt -- 开箱人20要素
            ,opener_opnacctchk -- 开箱人开户核查结果:1-通过；2-不通过
            ,opener_kycchk -- 开箱人KYC核查结果:1-通过；2-不通过
            ,opener_fxqchk -- 开箱人反洗钱核查结果:1-通过；2-不通过
            ,opener_lwhcchk -- 开箱人联网核查结果:1-通过；2-不通过
            ,co_opnrs_9_elmnt -- 联名开箱人9要素
            ,co_opener_opnacctchk -- 联名开箱人开户核查结果:1-通过；2-不通过
            ,co_opener_kycchk -- 联名开箱人KYC核查结果:1-通过；2-不通过
            ,co_opener_fxqchk -- 联名开箱人反洗钱核查结果:1-通过；2-不通过
            ,co_opener_lwhcchk -- 联名开箱人联网核查结果:1-通过；2-不通过
            ,agent_9_elmnt -- 代理人4要素
            ,agent_opnacctchk -- 代理人开户核查结果:1-通过；2-不通过
            ,agent_kycchk -- 代理人KYC核查结果:1-通过；2-不通过
            ,agent_fxqchk -- 代理人反洗钱核查结果:1-通过；2-不通过
            ,agent_lwhcchk -- 代理人联网核查结果:1-通过；2-不通过
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,chn_id -- 渠道号
            ,brcno -- 机构号
            ,tlrno -- 处理柜员
            ,authtlrno -- 授权柜员
            ,hangseqno -- 挂销账流水
            ,dsttrncd -- 第三方交易码
            ,hostdt -- 核心日期
            ,hostseqno -- 核心流水
            ,status -- 交易状态
            ,abscde -- 会计分录
            ,dataid -- 记账子流水
            ,ucstat -- 冲正状态：1-已冲正
            ,rspcd -- 应答码
            ,rspmsg -- 应答信息
            ,uc_glob_seq_num -- 冲正全局流水
            ,uc_err_msg -- 冲正失败信息
            ,uc_times -- 冲正次数
            ,upd_time -- 更新时间
            ,rentboxdate -- 租箱日期
            ,rentboxenddt -- 租箱到期日
            ,rentboxstatus -- 租箱状态 0-租箱失败;1-租箱;2-退箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a20tsafeboxinf_op(
            mainseq -- 中台流水
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fnttrncd -- 交易码
            ,safebox -- 保管箱编号
            ,custtype -- 客户类型
            ,custnm -- 客户名称
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,payacct -- 付款账号
            ,subseqno -- 子账户
            ,payname -- 付款人名称
            ,payprodtype -- 付款方产品类型
            ,incoacct -- 收款账号
            ,incosubseqno -- 收款方子账户
            ,inconame -- 收款人名称
            ,incoprodtype -- 收款方产品类型
            ,deposit -- 押金
            ,ccy -- 币种
            ,doctype -- 凭证类型
            ,docno -- 凭证号码
            ,draftdate -- 凭证到日期
            ,fundsource -- 资金来源:1-现金；2-客户转账；3-内部户转账
            ,opnrs_9_elmnt -- 开箱人9要素
            ,opnrs_20_elmnt -- 开箱人20要素
            ,opener_opnacctchk -- 开箱人开户核查结果:1-通过；2-不通过
            ,opener_kycchk -- 开箱人KYC核查结果:1-通过；2-不通过
            ,opener_fxqchk -- 开箱人反洗钱核查结果:1-通过；2-不通过
            ,opener_lwhcchk -- 开箱人联网核查结果:1-通过；2-不通过
            ,co_opnrs_9_elmnt -- 联名开箱人9要素
            ,co_opener_opnacctchk -- 联名开箱人开户核查结果:1-通过；2-不通过
            ,co_opener_kycchk -- 联名开箱人KYC核查结果:1-通过；2-不通过
            ,co_opener_fxqchk -- 联名开箱人反洗钱核查结果:1-通过；2-不通过
            ,co_opener_lwhcchk -- 联名开箱人联网核查结果:1-通过；2-不通过
            ,agent_9_elmnt -- 代理人4要素
            ,agent_opnacctchk -- 代理人开户核查结果:1-通过；2-不通过
            ,agent_kycchk -- 代理人KYC核查结果:1-通过；2-不通过
            ,agent_fxqchk -- 代理人反洗钱核查结果:1-通过；2-不通过
            ,agent_lwhcchk -- 代理人联网核查结果:1-通过；2-不通过
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,chn_id -- 渠道号
            ,brcno -- 机构号
            ,tlrno -- 处理柜员
            ,authtlrno -- 授权柜员
            ,hangseqno -- 挂销账流水
            ,dsttrncd -- 第三方交易码
            ,hostdt -- 核心日期
            ,hostseqno -- 核心流水
            ,status -- 交易状态
            ,abscde -- 会计分录
            ,dataid -- 记账子流水
            ,ucstat -- 冲正状态：1-已冲正
            ,rspcd -- 应答码
            ,rspmsg -- 应答信息
            ,uc_glob_seq_num -- 冲正全局流水
            ,uc_err_msg -- 冲正失败信息
            ,uc_times -- 冲正次数
            ,upd_time -- 更新时间
            ,rentboxdate -- 租箱日期
            ,rentboxenddt -- 租箱到期日
            ,rentboxstatus -- 租箱状态 0-租箱失败;1-租箱;2-退箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mainseq, o.mainseq) as mainseq -- 中台流水
    ,nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.transtm, o.transtm) as transtm -- 交易时间
    ,nvl(n.fnttrncd, o.fnttrncd) as fnttrncd -- 交易码
    ,nvl(n.safebox, o.safebox) as safebox -- 保管箱编号
    ,nvl(n.custtype, o.custtype) as custtype -- 客户类型
    ,nvl(n.custnm, o.custnm) as custnm -- 客户名称
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idno, o.idno) as idno -- 证件号码
    ,nvl(n.payacct, o.payacct) as payacct -- 付款账号
    ,nvl(n.subseqno, o.subseqno) as subseqno -- 子账户
    ,nvl(n.payname, o.payname) as payname -- 付款人名称
    ,nvl(n.payprodtype, o.payprodtype) as payprodtype -- 付款方产品类型
    ,nvl(n.incoacct, o.incoacct) as incoacct -- 收款账号
    ,nvl(n.incosubseqno, o.incosubseqno) as incosubseqno -- 收款方子账户
    ,nvl(n.inconame, o.inconame) as inconame -- 收款人名称
    ,nvl(n.incoprodtype, o.incoprodtype) as incoprodtype -- 收款方产品类型
    ,nvl(n.deposit, o.deposit) as deposit -- 押金
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.doctype, o.doctype) as doctype -- 凭证类型
    ,nvl(n.docno, o.docno) as docno -- 凭证号码
    ,nvl(n.draftdate, o.draftdate) as draftdate -- 凭证到日期
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源:1-现金；2-客户转账；3-内部户转账
    ,nvl(n.opnrs_9_elmnt, o.opnrs_9_elmnt) as opnrs_9_elmnt -- 开箱人9要素
    ,nvl(n.opnrs_20_elmnt, o.opnrs_20_elmnt) as opnrs_20_elmnt -- 开箱人20要素
    ,nvl(n.opener_opnacctchk, o.opener_opnacctchk) as opener_opnacctchk -- 开箱人开户核查结果:1-通过；2-不通过
    ,nvl(n.opener_kycchk, o.opener_kycchk) as opener_kycchk -- 开箱人KYC核查结果:1-通过；2-不通过
    ,nvl(n.opener_fxqchk, o.opener_fxqchk) as opener_fxqchk -- 开箱人反洗钱核查结果:1-通过；2-不通过
    ,nvl(n.opener_lwhcchk, o.opener_lwhcchk) as opener_lwhcchk -- 开箱人联网核查结果:1-通过；2-不通过
    ,nvl(n.co_opnrs_9_elmnt, o.co_opnrs_9_elmnt) as co_opnrs_9_elmnt -- 联名开箱人9要素
    ,nvl(n.co_opener_opnacctchk, o.co_opener_opnacctchk) as co_opener_opnacctchk -- 联名开箱人开户核查结果:1-通过；2-不通过
    ,nvl(n.co_opener_kycchk, o.co_opener_kycchk) as co_opener_kycchk -- 联名开箱人KYC核查结果:1-通过；2-不通过
    ,nvl(n.co_opener_fxqchk, o.co_opener_fxqchk) as co_opener_fxqchk -- 联名开箱人反洗钱核查结果:1-通过；2-不通过
    ,nvl(n.co_opener_lwhcchk, o.co_opener_lwhcchk) as co_opener_lwhcchk -- 联名开箱人联网核查结果:1-通过；2-不通过
    ,nvl(n.agent_9_elmnt, o.agent_9_elmnt) as agent_9_elmnt -- 代理人4要素
    ,nvl(n.agent_opnacctchk, o.agent_opnacctchk) as agent_opnacctchk -- 代理人开户核查结果:1-通过；2-不通过
    ,nvl(n.agent_kycchk, o.agent_kycchk) as agent_kycchk -- 代理人KYC核查结果:1-通过；2-不通过
    ,nvl(n.agent_fxqchk, o.agent_fxqchk) as agent_fxqchk -- 代理人反洗钱核查结果:1-通过；2-不通过
    ,nvl(n.agent_lwhcchk, o.agent_lwhcchk) as agent_lwhcchk -- 代理人联网核查结果:1-通过；2-不通过
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号
    ,nvl(n.unique_seq_num, o.unique_seq_num) as unique_seq_num -- 业务流水号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道号
    ,nvl(n.brcno, o.brcno) as brcno -- 机构号
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 处理柜员
    ,nvl(n.authtlrno, o.authtlrno) as authtlrno -- 授权柜员
    ,nvl(n.hangseqno, o.hangseqno) as hangseqno -- 挂销账流水
    ,nvl(n.dsttrncd, o.dsttrncd) as dsttrncd -- 第三方交易码
    ,nvl(n.hostdt, o.hostdt) as hostdt -- 核心日期
    ,nvl(n.hostseqno, o.hostseqno) as hostseqno -- 核心流水
    ,nvl(n.status, o.status) as status -- 交易状态
    ,nvl(n.abscde, o.abscde) as abscde -- 会计分录
    ,nvl(n.dataid, o.dataid) as dataid -- 记账子流水
    ,nvl(n.ucstat, o.ucstat) as ucstat -- 冲正状态：1-已冲正
    ,nvl(n.rspcd, o.rspcd) as rspcd -- 应答码
    ,nvl(n.rspmsg, o.rspmsg) as rspmsg -- 应答信息
    ,nvl(n.uc_glob_seq_num, o.uc_glob_seq_num) as uc_glob_seq_num -- 冲正全局流水
    ,nvl(n.uc_err_msg, o.uc_err_msg) as uc_err_msg -- 冲正失败信息
    ,nvl(n.uc_times, o.uc_times) as uc_times -- 冲正次数
    ,nvl(n.upd_time, o.upd_time) as upd_time -- 更新时间
    ,nvl(n.rentboxdate, o.rentboxdate) as rentboxdate -- 租箱日期
    ,nvl(n.rentboxenddt, o.rentboxenddt) as rentboxenddt -- 租箱到期日
    ,nvl(n.rentboxstatus, o.rentboxstatus) as rentboxstatus -- 租箱状态 0-租箱失败;1-租箱;2-退箱
    ,case when
            n.mainseq is null
            and n.transdt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mainseq is null
            and n.transdt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mainseq is null
            and n.transdt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a20tsafeboxinf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a20tsafeboxinf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
where (
        o.mainseq is null
        and o.transdt is null
    )
    or (
        n.mainseq is null
        and n.transdt is null
    )
    or (
        o.transtm <> n.transtm
        or o.fnttrncd <> n.fnttrncd
        or o.safebox <> n.safebox
        or o.custtype <> n.custtype
        or o.custnm <> n.custnm
        or o.custno <> n.custno
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.payacct <> n.payacct
        or o.subseqno <> n.subseqno
        or o.payname <> n.payname
        or o.payprodtype <> n.payprodtype
        or o.incoacct <> n.incoacct
        or o.incosubseqno <> n.incosubseqno
        or o.inconame <> n.inconame
        or o.incoprodtype <> n.incoprodtype
        or o.deposit <> n.deposit
        or o.ccy <> n.ccy
        or o.doctype <> n.doctype
        or o.docno <> n.docno
        or o.draftdate <> n.draftdate
        or o.fundsource <> n.fundsource
        or o.opnrs_9_elmnt <> n.opnrs_9_elmnt
        or o.opnrs_20_elmnt <> n.opnrs_20_elmnt
        or o.opener_opnacctchk <> n.opener_opnacctchk
        or o.opener_kycchk <> n.opener_kycchk
        or o.opener_fxqchk <> n.opener_fxqchk
        or o.opener_lwhcchk <> n.opener_lwhcchk
        or o.co_opnrs_9_elmnt <> n.co_opnrs_9_elmnt
        or o.co_opener_opnacctchk <> n.co_opener_opnacctchk
        or o.co_opener_kycchk <> n.co_opener_kycchk
        or o.co_opener_fxqchk <> n.co_opener_fxqchk
        or o.co_opener_lwhcchk <> n.co_opener_lwhcchk
        or o.agent_9_elmnt <> n.agent_9_elmnt
        or o.agent_opnacctchk <> n.agent_opnacctchk
        or o.agent_kycchk <> n.agent_kycchk
        or o.agent_fxqchk <> n.agent_fxqchk
        or o.agent_lwhcchk <> n.agent_lwhcchk
        or o.glob_seq_num <> n.glob_seq_num
        or o.unique_seq_num <> n.unique_seq_num
        or o.chn_id <> n.chn_id
        or o.brcno <> n.brcno
        or o.tlrno <> n.tlrno
        or o.authtlrno <> n.authtlrno
        or o.hangseqno <> n.hangseqno
        or o.dsttrncd <> n.dsttrncd
        or o.hostdt <> n.hostdt
        or o.hostseqno <> n.hostseqno
        or o.status <> n.status
        or o.abscde <> n.abscde
        or o.dataid <> n.dataid
        or o.ucstat <> n.ucstat
        or o.rspcd <> n.rspcd
        or o.rspmsg <> n.rspmsg
        or o.uc_glob_seq_num <> n.uc_glob_seq_num
        or o.uc_err_msg <> n.uc_err_msg
        or o.uc_times <> n.uc_times
        or o.upd_time <> n.upd_time
        or o.rentboxdate <> n.rentboxdate
        or o.rentboxenddt <> n.rentboxenddt
        or o.rentboxstatus <> n.rentboxstatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a20tsafeboxinf_cl(
            mainseq -- 中台流水
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fnttrncd -- 交易码
            ,safebox -- 保管箱编号
            ,custtype -- 客户类型
            ,custnm -- 客户名称
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,payacct -- 付款账号
            ,subseqno -- 子账户
            ,payname -- 付款人名称
            ,payprodtype -- 付款方产品类型
            ,incoacct -- 收款账号
            ,incosubseqno -- 收款方子账户
            ,inconame -- 收款人名称
            ,incoprodtype -- 收款方产品类型
            ,deposit -- 押金
            ,ccy -- 币种
            ,doctype -- 凭证类型
            ,docno -- 凭证号码
            ,draftdate -- 凭证到日期
            ,fundsource -- 资金来源:1-现金；2-客户转账；3-内部户转账
            ,opnrs_9_elmnt -- 开箱人9要素
            ,opnrs_20_elmnt -- 开箱人20要素
            ,opener_opnacctchk -- 开箱人开户核查结果:1-通过；2-不通过
            ,opener_kycchk -- 开箱人KYC核查结果:1-通过；2-不通过
            ,opener_fxqchk -- 开箱人反洗钱核查结果:1-通过；2-不通过
            ,opener_lwhcchk -- 开箱人联网核查结果:1-通过；2-不通过
            ,co_opnrs_9_elmnt -- 联名开箱人9要素
            ,co_opener_opnacctchk -- 联名开箱人开户核查结果:1-通过；2-不通过
            ,co_opener_kycchk -- 联名开箱人KYC核查结果:1-通过；2-不通过
            ,co_opener_fxqchk -- 联名开箱人反洗钱核查结果:1-通过；2-不通过
            ,co_opener_lwhcchk -- 联名开箱人联网核查结果:1-通过；2-不通过
            ,agent_9_elmnt -- 代理人4要素
            ,agent_opnacctchk -- 代理人开户核查结果:1-通过；2-不通过
            ,agent_kycchk -- 代理人KYC核查结果:1-通过；2-不通过
            ,agent_fxqchk -- 代理人反洗钱核查结果:1-通过；2-不通过
            ,agent_lwhcchk -- 代理人联网核查结果:1-通过；2-不通过
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,chn_id -- 渠道号
            ,brcno -- 机构号
            ,tlrno -- 处理柜员
            ,authtlrno -- 授权柜员
            ,hangseqno -- 挂销账流水
            ,dsttrncd -- 第三方交易码
            ,hostdt -- 核心日期
            ,hostseqno -- 核心流水
            ,status -- 交易状态
            ,abscde -- 会计分录
            ,dataid -- 记账子流水
            ,ucstat -- 冲正状态：1-已冲正
            ,rspcd -- 应答码
            ,rspmsg -- 应答信息
            ,uc_glob_seq_num -- 冲正全局流水
            ,uc_err_msg -- 冲正失败信息
            ,uc_times -- 冲正次数
            ,upd_time -- 更新时间
            ,rentboxdate -- 租箱日期
            ,rentboxenddt -- 租箱到期日
            ,rentboxstatus -- 租箱状态 0-租箱失败;1-租箱;2-退箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a20tsafeboxinf_op(
            mainseq -- 中台流水
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fnttrncd -- 交易码
            ,safebox -- 保管箱编号
            ,custtype -- 客户类型
            ,custnm -- 客户名称
            ,custno -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,payacct -- 付款账号
            ,subseqno -- 子账户
            ,payname -- 付款人名称
            ,payprodtype -- 付款方产品类型
            ,incoacct -- 收款账号
            ,incosubseqno -- 收款方子账户
            ,inconame -- 收款人名称
            ,incoprodtype -- 收款方产品类型
            ,deposit -- 押金
            ,ccy -- 币种
            ,doctype -- 凭证类型
            ,docno -- 凭证号码
            ,draftdate -- 凭证到日期
            ,fundsource -- 资金来源:1-现金；2-客户转账；3-内部户转账
            ,opnrs_9_elmnt -- 开箱人9要素
            ,opnrs_20_elmnt -- 开箱人20要素
            ,opener_opnacctchk -- 开箱人开户核查结果:1-通过；2-不通过
            ,opener_kycchk -- 开箱人KYC核查结果:1-通过；2-不通过
            ,opener_fxqchk -- 开箱人反洗钱核查结果:1-通过；2-不通过
            ,opener_lwhcchk -- 开箱人联网核查结果:1-通过；2-不通过
            ,co_opnrs_9_elmnt -- 联名开箱人9要素
            ,co_opener_opnacctchk -- 联名开箱人开户核查结果:1-通过；2-不通过
            ,co_opener_kycchk -- 联名开箱人KYC核查结果:1-通过；2-不通过
            ,co_opener_fxqchk -- 联名开箱人反洗钱核查结果:1-通过；2-不通过
            ,co_opener_lwhcchk -- 联名开箱人联网核查结果:1-通过；2-不通过
            ,agent_9_elmnt -- 代理人4要素
            ,agent_opnacctchk -- 代理人开户核查结果:1-通过；2-不通过
            ,agent_kycchk -- 代理人KYC核查结果:1-通过；2-不通过
            ,agent_fxqchk -- 代理人反洗钱核查结果:1-通过；2-不通过
            ,agent_lwhcchk -- 代理人联网核查结果:1-通过；2-不通过
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,chn_id -- 渠道号
            ,brcno -- 机构号
            ,tlrno -- 处理柜员
            ,authtlrno -- 授权柜员
            ,hangseqno -- 挂销账流水
            ,dsttrncd -- 第三方交易码
            ,hostdt -- 核心日期
            ,hostseqno -- 核心流水
            ,status -- 交易状态
            ,abscde -- 会计分录
            ,dataid -- 记账子流水
            ,ucstat -- 冲正状态：1-已冲正
            ,rspcd -- 应答码
            ,rspmsg -- 应答信息
            ,uc_glob_seq_num -- 冲正全局流水
            ,uc_err_msg -- 冲正失败信息
            ,uc_times -- 冲正次数
            ,upd_time -- 更新时间
            ,rentboxdate -- 租箱日期
            ,rentboxenddt -- 租箱到期日
            ,rentboxstatus -- 租箱状态 0-租箱失败;1-租箱;2-退箱
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mainseq -- 中台流水
    ,o.transdt -- 交易日期
    ,o.transtm -- 交易时间
    ,o.fnttrncd -- 交易码
    ,o.safebox -- 保管箱编号
    ,o.custtype -- 客户类型
    ,o.custnm -- 客户名称
    ,o.custno -- 客户号
    ,o.idtype -- 证件类型
    ,o.idno -- 证件号码
    ,o.payacct -- 付款账号
    ,o.subseqno -- 子账户
    ,o.payname -- 付款人名称
    ,o.payprodtype -- 付款方产品类型
    ,o.incoacct -- 收款账号
    ,o.incosubseqno -- 收款方子账户
    ,o.inconame -- 收款人名称
    ,o.incoprodtype -- 收款方产品类型
    ,o.deposit -- 押金
    ,o.ccy -- 币种
    ,o.doctype -- 凭证类型
    ,o.docno -- 凭证号码
    ,o.draftdate -- 凭证到日期
    ,o.fundsource -- 资金来源:1-现金；2-客户转账；3-内部户转账
    ,o.opnrs_9_elmnt -- 开箱人9要素
    ,o.opnrs_20_elmnt -- 开箱人20要素
    ,o.opener_opnacctchk -- 开箱人开户核查结果:1-通过；2-不通过
    ,o.opener_kycchk -- 开箱人KYC核查结果:1-通过；2-不通过
    ,o.opener_fxqchk -- 开箱人反洗钱核查结果:1-通过；2-不通过
    ,o.opener_lwhcchk -- 开箱人联网核查结果:1-通过；2-不通过
    ,o.co_opnrs_9_elmnt -- 联名开箱人9要素
    ,o.co_opener_opnacctchk -- 联名开箱人开户核查结果:1-通过；2-不通过
    ,o.co_opener_kycchk -- 联名开箱人KYC核查结果:1-通过；2-不通过
    ,o.co_opener_fxqchk -- 联名开箱人反洗钱核查结果:1-通过；2-不通过
    ,o.co_opener_lwhcchk -- 联名开箱人联网核查结果:1-通过；2-不通过
    ,o.agent_9_elmnt -- 代理人4要素
    ,o.agent_opnacctchk -- 代理人开户核查结果:1-通过；2-不通过
    ,o.agent_kycchk -- 代理人KYC核查结果:1-通过；2-不通过
    ,o.agent_fxqchk -- 代理人反洗钱核查结果:1-通过；2-不通过
    ,o.agent_lwhcchk -- 代理人联网核查结果:1-通过；2-不通过
    ,o.glob_seq_num -- 全局流水号
    ,o.unique_seq_num -- 业务流水号
    ,o.chn_id -- 渠道号
    ,o.brcno -- 机构号
    ,o.tlrno -- 处理柜员
    ,o.authtlrno -- 授权柜员
    ,o.hangseqno -- 挂销账流水
    ,o.dsttrncd -- 第三方交易码
    ,o.hostdt -- 核心日期
    ,o.hostseqno -- 核心流水
    ,o.status -- 交易状态
    ,o.abscde -- 会计分录
    ,o.dataid -- 记账子流水
    ,o.ucstat -- 冲正状态：1-已冲正
    ,o.rspcd -- 应答码
    ,o.rspmsg -- 应答信息
    ,o.uc_glob_seq_num -- 冲正全局流水
    ,o.uc_err_msg -- 冲正失败信息
    ,o.uc_times -- 冲正次数
    ,o.upd_time -- 更新时间
    ,o.rentboxdate -- 租箱日期
    ,o.rentboxenddt -- 租箱到期日
    ,o.rentboxstatus -- 租箱状态 0-租箱失败;1-租箱;2-退箱
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
from ${iol_schema}.mpcs_a20tsafeboxinf_bk o
    left join ${iol_schema}.mpcs_a20tsafeboxinf_op n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a20tsafeboxinf_cl d
        on
            o.mainseq = d.mainseq
            and o.transdt = d.transdt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a20tsafeboxinf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a20tsafeboxinf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a20tsafeboxinf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a20tsafeboxinf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a20tsafeboxinf exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a20tsafeboxinf_cl;
alter table ${iol_schema}.mpcs_a20tsafeboxinf exchange partition p_20991231 with table ${iol_schema}.mpcs_a20tsafeboxinf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a20tsafeboxinf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a20tsafeboxinf_op purge;
drop table ${iol_schema}.mpcs_a20tsafeboxinf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a20tsafeboxinf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a20tsafeboxinf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
