/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0tbfreezefb
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
create table ${iol_schema}.mpcs_a0tbfreezefb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0tbfreezefb;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0tbfreezefb_op purge;
drop table ${iol_schema}.mpcs_a0tbfreezefb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0tbfreezefb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0tbfreezefb where 0=1;

create table ${iol_schema}.mpcs_a0tbfreezefb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0tbfreezefb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0tbfreezefb_cl(
            orgtransserialnumber -- 原传输报文流水号
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fkmode -- 默认值01
            ,tobrcno -- 接收机构ID（对应下行报文中的MessageFrom值）
            ,txcode -- 交易类型编码100202
            ,transserialnumber -- 传输报文流水号
            ,applicationid -- 业务申请编号
            ,result -- 冻结结果/冻结解除结果
            ,accounttype -- 冻结账号类别（01-个人；02-对公）
            ,accountnumber -- 冻结帐卡号(与原冻结报文帐卡号相同)
            ,cardnumber -- 卡/折号(对私业务时需填写)
            ,appliedbalance -- 申请冻结限额(单位到元)（"-"）
            ,frozedbalance -- 执行冻结金额(单位到元)
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,accountbalance -- 账户余额(冻结时刻的账户金额)
            ,starttime -- 冻结起始时间(yyyyMMddHHmmss)
            ,expiretime -- 冻结结束时间(yyyyMMddHHmmss)
            ,failurecause -- 未能冻结原因
            ,formerapplicationdepartment -- 在先冻结机关(上一个轮候机关)
            ,formerfrozencurrency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,formerfrozenbalance -- 在先冻结金额
            ,formerfrozenexpiretime -- 在先冻结到期时间(yyyyMMddHHmmss)
            ,accountavaiablebalance -- 冻结后账户可用余额(冻结后的可用余额)
            ,feedbackremark -- 反馈说明
            ,feedbackorgname -- 反馈机构名称
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,hostdt -- 冻结核心交易日期
            ,hostseqno -- 冻结核心交易流水
            ,dataid -- 中台流水
            ,status -- 处理状态 0-未处理 1-已处理 2-处理失败
            ,times -- 发送次数
            ,code -- 返回码
            ,retutransserialnumber -- 返回报文--传输报文流水号
            ,description -- 返回消息
            ,lastmodifytm -- 最后修改时间
            ,unfreezebalance -- 解除冻结金额
            ,withdrawaltime -- 冻结解除生效时间
            ,openbr -- 开立机构
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0tbfreezefb_op(
            orgtransserialnumber -- 原传输报文流水号
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fkmode -- 默认值01
            ,tobrcno -- 接收机构ID（对应下行报文中的MessageFrom值）
            ,txcode -- 交易类型编码100202
            ,transserialnumber -- 传输报文流水号
            ,applicationid -- 业务申请编号
            ,result -- 冻结结果/冻结解除结果
            ,accounttype -- 冻结账号类别（01-个人；02-对公）
            ,accountnumber -- 冻结帐卡号(与原冻结报文帐卡号相同)
            ,cardnumber -- 卡/折号(对私业务时需填写)
            ,appliedbalance -- 申请冻结限额(单位到元)（"-"）
            ,frozedbalance -- 执行冻结金额(单位到元)
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,accountbalance -- 账户余额(冻结时刻的账户金额)
            ,starttime -- 冻结起始时间(yyyyMMddHHmmss)
            ,expiretime -- 冻结结束时间(yyyyMMddHHmmss)
            ,failurecause -- 未能冻结原因
            ,formerapplicationdepartment -- 在先冻结机关(上一个轮候机关)
            ,formerfrozencurrency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,formerfrozenbalance -- 在先冻结金额
            ,formerfrozenexpiretime -- 在先冻结到期时间(yyyyMMddHHmmss)
            ,accountavaiablebalance -- 冻结后账户可用余额(冻结后的可用余额)
            ,feedbackremark -- 反馈说明
            ,feedbackorgname -- 反馈机构名称
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,hostdt -- 冻结核心交易日期
            ,hostseqno -- 冻结核心交易流水
            ,dataid -- 中台流水
            ,status -- 处理状态 0-未处理 1-已处理 2-处理失败
            ,times -- 发送次数
            ,code -- 返回码
            ,retutransserialnumber -- 返回报文--传输报文流水号
            ,description -- 返回消息
            ,lastmodifytm -- 最后修改时间
            ,unfreezebalance -- 解除冻结金额
            ,withdrawaltime -- 冻结解除生效时间
            ,openbr -- 开立机构
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.orgtransserialnumber, o.orgtransserialnumber) as orgtransserialnumber -- 原传输报文流水号
    ,nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.transtm, o.transtm) as transtm -- 交易时间
    ,nvl(n.fkmode, o.fkmode) as fkmode -- 默认值01
    ,nvl(n.tobrcno, o.tobrcno) as tobrcno -- 接收机构ID（对应下行报文中的MessageFrom值）
    ,nvl(n.txcode, o.txcode) as txcode -- 交易类型编码100202
    ,nvl(n.transserialnumber, o.transserialnumber) as transserialnumber -- 传输报文流水号
    ,nvl(n.applicationid, o.applicationid) as applicationid -- 业务申请编号
    ,nvl(n.result, o.result) as result -- 冻结结果/冻结解除结果
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 冻结账号类别（01-个人；02-对公）
    ,nvl(n.accountnumber, o.accountnumber) as accountnumber -- 冻结帐卡号(与原冻结报文帐卡号相同)
    ,nvl(n.cardnumber, o.cardnumber) as cardnumber -- 卡/折号(对私业务时需填写)
    ,nvl(n.appliedbalance, o.appliedbalance) as appliedbalance -- 申请冻结限额(单位到元)（"-"）
    ,nvl(n.frozedbalance, o.frozedbalance) as frozedbalance -- 执行冻结金额(单位到元)
    ,nvl(n.currency, o.currency) as currency -- 币种(CNY人民币、USD美元、EUR欧元…)
    ,nvl(n.accountbalance, o.accountbalance) as accountbalance -- 账户余额(冻结时刻的账户金额)
    ,nvl(n.starttime, o.starttime) as starttime -- 冻结起始时间(yyyyMMddHHmmss)
    ,nvl(n.expiretime, o.expiretime) as expiretime -- 冻结结束时间(yyyyMMddHHmmss)
    ,nvl(n.failurecause, o.failurecause) as failurecause -- 未能冻结原因
    ,nvl(n.formerapplicationdepartment, o.formerapplicationdepartment) as formerapplicationdepartment -- 在先冻结机关(上一个轮候机关)
    ,nvl(n.formerfrozencurrency, o.formerfrozencurrency) as formerfrozencurrency -- 币种(CNY人民币、USD美元、EUR欧元…)
    ,nvl(n.formerfrozenbalance, o.formerfrozenbalance) as formerfrozenbalance -- 在先冻结金额
    ,nvl(n.formerfrozenexpiretime, o.formerfrozenexpiretime) as formerfrozenexpiretime -- 在先冻结到期时间(yyyyMMddHHmmss)
    ,nvl(n.accountavaiablebalance, o.accountavaiablebalance) as accountavaiablebalance -- 冻结后账户可用余额(冻结后的可用余额)
    ,nvl(n.feedbackremark, o.feedbackremark) as feedbackremark -- 反馈说明
    ,nvl(n.feedbackorgname, o.feedbackorgname) as feedbackorgname -- 反馈机构名称
    ,nvl(n.operatorname, o.operatorname) as operatorname -- 经办人姓名
    ,nvl(n.operatorphonenumber, o.operatorphonenumber) as operatorphonenumber -- 经办人电话
    ,nvl(n.hostdt, o.hostdt) as hostdt -- 冻结核心交易日期
    ,nvl(n.hostseqno, o.hostseqno) as hostseqno -- 冻结核心交易流水
    ,nvl(n.dataid, o.dataid) as dataid -- 中台流水
    ,nvl(n.status, o.status) as status -- 处理状态 0-未处理 1-已处理 2-处理失败
    ,nvl(n.times, o.times) as times -- 发送次数
    ,nvl(n.code, o.code) as code -- 返回码
    ,nvl(n.retutransserialnumber, o.retutransserialnumber) as retutransserialnumber -- 返回报文--传输报文流水号
    ,nvl(n.description, o.description) as description -- 返回消息
    ,nvl(n.lastmodifytm, o.lastmodifytm) as lastmodifytm -- 最后修改时间
    ,nvl(n.unfreezebalance, o.unfreezebalance) as unfreezebalance -- 解除冻结金额
    ,nvl(n.withdrawaltime, o.withdrawaltime) as withdrawaltime -- 冻结解除生效时间
    ,nvl(n.openbr, o.openbr) as openbr -- 开立机构
    ,nvl(n.upptransid, o.upptransid) as upptransid -- UPP流水
    ,nvl(n.subsac, o.subsac) as subsac -- 子账号
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类级
    ,case when
            n.orgtransserialnumber is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.orgtransserialnumber is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.orgtransserialnumber is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0tbfreezefb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0tbfreezefb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.orgtransserialnumber = n.orgtransserialnumber
where (
        o.orgtransserialnumber is null
    )
    or (
        n.orgtransserialnumber is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.fkmode <> n.fkmode
        or o.tobrcno <> n.tobrcno
        or o.txcode <> n.txcode
        or o.transserialnumber <> n.transserialnumber
        or o.applicationid <> n.applicationid
        or o.result <> n.result
        or o.accounttype <> n.accounttype
        or o.accountnumber <> n.accountnumber
        or o.cardnumber <> n.cardnumber
        or o.appliedbalance <> n.appliedbalance
        or o.frozedbalance <> n.frozedbalance
        or o.currency <> n.currency
        or o.accountbalance <> n.accountbalance
        or o.starttime <> n.starttime
        or o.expiretime <> n.expiretime
        or o.failurecause <> n.failurecause
        or o.formerapplicationdepartment <> n.formerapplicationdepartment
        or o.formerfrozencurrency <> n.formerfrozencurrency
        or o.formerfrozenbalance <> n.formerfrozenbalance
        or o.formerfrozenexpiretime <> n.formerfrozenexpiretime
        or o.accountavaiablebalance <> n.accountavaiablebalance
        or o.feedbackremark <> n.feedbackremark
        or o.feedbackorgname <> n.feedbackorgname
        or o.operatorname <> n.operatorname
        or o.operatorphonenumber <> n.operatorphonenumber
        or o.hostdt <> n.hostdt
        or o.hostseqno <> n.hostseqno
        or o.dataid <> n.dataid
        or o.status <> n.status
        or o.times <> n.times
        or o.code <> n.code
        or o.retutransserialnumber <> n.retutransserialnumber
        or o.description <> n.description
        or o.lastmodifytm <> n.lastmodifytm
        or o.unfreezebalance <> n.unfreezebalance
        or o.withdrawaltime <> n.withdrawaltime
        or o.openbr <> n.openbr
        or o.upptransid <> n.upptransid
        or o.subsac <> n.subsac
        or o.accttype <> n.accttype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0tbfreezefb_cl(
            orgtransserialnumber -- 原传输报文流水号
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fkmode -- 默认值01
            ,tobrcno -- 接收机构ID（对应下行报文中的MessageFrom值）
            ,txcode -- 交易类型编码100202
            ,transserialnumber -- 传输报文流水号
            ,applicationid -- 业务申请编号
            ,result -- 冻结结果/冻结解除结果
            ,accounttype -- 冻结账号类别（01-个人；02-对公）
            ,accountnumber -- 冻结帐卡号(与原冻结报文帐卡号相同)
            ,cardnumber -- 卡/折号(对私业务时需填写)
            ,appliedbalance -- 申请冻结限额(单位到元)（"-"）
            ,frozedbalance -- 执行冻结金额(单位到元)
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,accountbalance -- 账户余额(冻结时刻的账户金额)
            ,starttime -- 冻结起始时间(yyyyMMddHHmmss)
            ,expiretime -- 冻结结束时间(yyyyMMddHHmmss)
            ,failurecause -- 未能冻结原因
            ,formerapplicationdepartment -- 在先冻结机关(上一个轮候机关)
            ,formerfrozencurrency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,formerfrozenbalance -- 在先冻结金额
            ,formerfrozenexpiretime -- 在先冻结到期时间(yyyyMMddHHmmss)
            ,accountavaiablebalance -- 冻结后账户可用余额(冻结后的可用余额)
            ,feedbackremark -- 反馈说明
            ,feedbackorgname -- 反馈机构名称
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,hostdt -- 冻结核心交易日期
            ,hostseqno -- 冻结核心交易流水
            ,dataid -- 中台流水
            ,status -- 处理状态 0-未处理 1-已处理 2-处理失败
            ,times -- 发送次数
            ,code -- 返回码
            ,retutransserialnumber -- 返回报文--传输报文流水号
            ,description -- 返回消息
            ,lastmodifytm -- 最后修改时间
            ,unfreezebalance -- 解除冻结金额
            ,withdrawaltime -- 冻结解除生效时间
            ,openbr -- 开立机构
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0tbfreezefb_op(
            orgtransserialnumber -- 原传输报文流水号
            ,transdt -- 交易日期
            ,transtm -- 交易时间
            ,fkmode -- 默认值01
            ,tobrcno -- 接收机构ID（对应下行报文中的MessageFrom值）
            ,txcode -- 交易类型编码100202
            ,transserialnumber -- 传输报文流水号
            ,applicationid -- 业务申请编号
            ,result -- 冻结结果/冻结解除结果
            ,accounttype -- 冻结账号类别（01-个人；02-对公）
            ,accountnumber -- 冻结帐卡号(与原冻结报文帐卡号相同)
            ,cardnumber -- 卡/折号(对私业务时需填写)
            ,appliedbalance -- 申请冻结限额(单位到元)（"-"）
            ,frozedbalance -- 执行冻结金额(单位到元)
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,accountbalance -- 账户余额(冻结时刻的账户金额)
            ,starttime -- 冻结起始时间(yyyyMMddHHmmss)
            ,expiretime -- 冻结结束时间(yyyyMMddHHmmss)
            ,failurecause -- 未能冻结原因
            ,formerapplicationdepartment -- 在先冻结机关(上一个轮候机关)
            ,formerfrozencurrency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,formerfrozenbalance -- 在先冻结金额
            ,formerfrozenexpiretime -- 在先冻结到期时间(yyyyMMddHHmmss)
            ,accountavaiablebalance -- 冻结后账户可用余额(冻结后的可用余额)
            ,feedbackremark -- 反馈说明
            ,feedbackorgname -- 反馈机构名称
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,hostdt -- 冻结核心交易日期
            ,hostseqno -- 冻结核心交易流水
            ,dataid -- 中台流水
            ,status -- 处理状态 0-未处理 1-已处理 2-处理失败
            ,times -- 发送次数
            ,code -- 返回码
            ,retutransserialnumber -- 返回报文--传输报文流水号
            ,description -- 返回消息
            ,lastmodifytm -- 最后修改时间
            ,unfreezebalance -- 解除冻结金额
            ,withdrawaltime -- 冻结解除生效时间
            ,openbr -- 开立机构
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.orgtransserialnumber -- 原传输报文流水号
    ,o.transdt -- 交易日期
    ,o.transtm -- 交易时间
    ,o.fkmode -- 默认值01
    ,o.tobrcno -- 接收机构ID（对应下行报文中的MessageFrom值）
    ,o.txcode -- 交易类型编码100202
    ,o.transserialnumber -- 传输报文流水号
    ,o.applicationid -- 业务申请编号
    ,o.result -- 冻结结果/冻结解除结果
    ,o.accounttype -- 冻结账号类别（01-个人；02-对公）
    ,o.accountnumber -- 冻结帐卡号(与原冻结报文帐卡号相同)
    ,o.cardnumber -- 卡/折号(对私业务时需填写)
    ,o.appliedbalance -- 申请冻结限额(单位到元)（"-"）
    ,o.frozedbalance -- 执行冻结金额(单位到元)
    ,o.currency -- 币种(CNY人民币、USD美元、EUR欧元…)
    ,o.accountbalance -- 账户余额(冻结时刻的账户金额)
    ,o.starttime -- 冻结起始时间(yyyyMMddHHmmss)
    ,o.expiretime -- 冻结结束时间(yyyyMMddHHmmss)
    ,o.failurecause -- 未能冻结原因
    ,o.formerapplicationdepartment -- 在先冻结机关(上一个轮候机关)
    ,o.formerfrozencurrency -- 币种(CNY人民币、USD美元、EUR欧元…)
    ,o.formerfrozenbalance -- 在先冻结金额
    ,o.formerfrozenexpiretime -- 在先冻结到期时间(yyyyMMddHHmmss)
    ,o.accountavaiablebalance -- 冻结后账户可用余额(冻结后的可用余额)
    ,o.feedbackremark -- 反馈说明
    ,o.feedbackorgname -- 反馈机构名称
    ,o.operatorname -- 经办人姓名
    ,o.operatorphonenumber -- 经办人电话
    ,o.hostdt -- 冻结核心交易日期
    ,o.hostseqno -- 冻结核心交易流水
    ,o.dataid -- 中台流水
    ,o.status -- 处理状态 0-未处理 1-已处理 2-处理失败
    ,o.times -- 发送次数
    ,o.code -- 返回码
    ,o.retutransserialnumber -- 返回报文--传输报文流水号
    ,o.description -- 返回消息
    ,o.lastmodifytm -- 最后修改时间
    ,o.unfreezebalance -- 解除冻结金额
    ,o.withdrawaltime -- 冻结解除生效时间
    ,o.openbr -- 开立机构
    ,o.upptransid -- UPP流水
    ,o.subsac -- 子账号
    ,o.accttype -- 账户类级
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0tbfreezefb_bk o
    left join ${iol_schema}.mpcs_a0tbfreezefb_op n
        on
            o.orgtransserialnumber = n.orgtransserialnumber
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0tbfreezefb_cl d
        on
            o.orgtransserialnumber = d.orgtransserialnumber
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0tbfreezefb;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0tbfreezefb exchange partition p_19000101 with table ${iol_schema}.mpcs_a0tbfreezefb_cl;
alter table ${iol_schema}.mpcs_a0tbfreezefb exchange partition p_20991231 with table ${iol_schema}.mpcs_a0tbfreezefb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0tbfreezefb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0tbfreezefb_op purge;
drop table ${iol_schema}.mpcs_a0tbfreezefb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0tbfreezefb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0tbfreezefb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
