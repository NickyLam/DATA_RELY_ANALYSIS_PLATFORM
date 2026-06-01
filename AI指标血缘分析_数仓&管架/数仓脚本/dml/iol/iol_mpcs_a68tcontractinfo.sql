/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a68tcontractinfo
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
create table ${iol_schema}.mpcs_a68tcontractinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a68tcontractinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a68tcontractinfo_op purge;
drop table ${iol_schema}.mpcs_a68tcontractinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tcontractinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a68tcontractinfo where 0=1;

create table ${iol_schema}.mpcs_a68tcontractinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a68tcontractinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a68tcontractinfo_cl(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,corprtnid -- 收付费企业代码
            ,pmtid -- 协议号
            ,reqid -- 申请号
            ,pmtitmcd -- 费项列表
            ,pmtitmnm -- 费项代码说明
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,issr -- 开户行行号
            ,issrnm -- 开户行名称
            ,accttype -- 账户类型
            ,acctid -- 账号/卡号
            ,ccy -- 币种
            ,oncddctnlmt -- 一次扣费限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,ctrctduedt -- 协议到期日期
            ,ctrctsgndt -- 协议签署日期
            ,ectdt -- 生效日期
            ,paypersna -- 缴费人名称
            ,paypersidtp -- 缴费人证件类型
            ,paypersid -- 缴费人证件号码
            ,tel -- 联系电话(预留手机号码)
            ,address -- 地址
            ,remark -- 备注/附言
            ,authmodel -- 授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）
            ,timeunit -- 扣款时间单位
            ,timestep -- 扣款时间步长
            ,timedesc -- 扣款时间描述
            ,moneylimit -- 扣款周期内扣费限额
            ,authcode -- 手机动态码
            ,status -- 签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝
            ,errmsg -- 错误信息
            ,dealinfo -- 中心处理说明
            ,authtlr -- 授权柜员
            ,authdt -- 授权日期
            ,authseqno -- 授权流水号
            ,authpmtid -- 授权协议号
            ,sendmsgflag -- 发送短信标识 0-未发送  1-已发送
            ,otpseqno -- 短信验证码验证流水
            ,uptm -- 更新时间
            ,authchl -- 授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)
            ,margbrn -- 处理机构(一般开户行)
            ,openbrnnm -- 开户机构名称(账户查询)
            ,uptransdt -- 协议变更申请日期
            ,uptranstm -- 协议变更申请时间
            ,upreqid -- 协议变更申请号
            ,upctrctduedt -- 协议变更申请的协议到期日
            ,upauthmodel -- 协议变更授权模式
            ,upotpseqno -- 协议变更短信验证流水
            ,upstatus -- 协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败
            ,uperrmsg -- 协议变更错误信息
            ,upauthdt -- 协议变更授权日期
            ,upauthseqno -- 协议授权流水号
            ,upauthtlr -- 协议变更授权柜员
            ,upauthchl -- 协议变更授权渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a68tcontractinfo_op(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,corprtnid -- 收付费企业代码
            ,pmtid -- 协议号
            ,reqid -- 申请号
            ,pmtitmcd -- 费项列表
            ,pmtitmnm -- 费项代码说明
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,issr -- 开户行行号
            ,issrnm -- 开户行名称
            ,accttype -- 账户类型
            ,acctid -- 账号/卡号
            ,ccy -- 币种
            ,oncddctnlmt -- 一次扣费限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,ctrctduedt -- 协议到期日期
            ,ctrctsgndt -- 协议签署日期
            ,ectdt -- 生效日期
            ,paypersna -- 缴费人名称
            ,paypersidtp -- 缴费人证件类型
            ,paypersid -- 缴费人证件号码
            ,tel -- 联系电话(预留手机号码)
            ,address -- 地址
            ,remark -- 备注/附言
            ,authmodel -- 授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）
            ,timeunit -- 扣款时间单位
            ,timestep -- 扣款时间步长
            ,timedesc -- 扣款时间描述
            ,moneylimit -- 扣款周期内扣费限额
            ,authcode -- 手机动态码
            ,status -- 签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝
            ,errmsg -- 错误信息
            ,dealinfo -- 中心处理说明
            ,authtlr -- 授权柜员
            ,authdt -- 授权日期
            ,authseqno -- 授权流水号
            ,authpmtid -- 授权协议号
            ,sendmsgflag -- 发送短信标识 0-未发送  1-已发送
            ,otpseqno -- 短信验证码验证流水
            ,uptm -- 更新时间
            ,authchl -- 授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)
            ,margbrn -- 处理机构(一般开户行)
            ,openbrnnm -- 开户机构名称(账户查询)
            ,uptransdt -- 协议变更申请日期
            ,uptranstm -- 协议变更申请时间
            ,upreqid -- 协议变更申请号
            ,upctrctduedt -- 协议变更申请的协议到期日
            ,upauthmodel -- 协议变更授权模式
            ,upotpseqno -- 协议变更短信验证流水
            ,upstatus -- 协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败
            ,uperrmsg -- 协议变更错误信息
            ,upauthdt -- 协议变更授权日期
            ,upauthseqno -- 协议授权流水号
            ,upauthtlr -- 协议变更授权柜员
            ,upauthchl -- 协议变更授权渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.transtm, o.transtm) as transtm -- 交易时间
    ,nvl(n.corprtnid, o.corprtnid) as corprtnid -- 收付费企业代码
    ,nvl(n.pmtid, o.pmtid) as pmtid -- 协议号
    ,nvl(n.reqid, o.reqid) as reqid -- 申请号
    ,nvl(n.pmtitmcd, o.pmtitmcd) as pmtitmcd -- 费项列表
    ,nvl(n.pmtitmnm, o.pmtitmnm) as pmtitmnm -- 费项代码说明
    ,nvl(n.cstmrid, o.cstmrid) as cstmrid -- 客户号
    ,nvl(n.cstmrnm, o.cstmrnm) as cstmrnm -- 客户名称
    ,nvl(n.issr, o.issr) as issr -- 开户行行号
    ,nvl(n.issrnm, o.issrnm) as issrnm -- 开户行名称
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类型
    ,nvl(n.acctid, o.acctid) as acctid -- 账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.oncddctnlmt, o.oncddctnlmt) as oncddctnlmt -- 一次扣费限额
    ,nvl(n.cycddctnnumlmt, o.cycddctnnumlmt) as cycddctnnumlmt -- 扣款周期内限制笔数
    ,nvl(n.ctrctduedt, o.ctrctduedt) as ctrctduedt -- 协议到期日期
    ,nvl(n.ctrctsgndt, o.ctrctsgndt) as ctrctsgndt -- 协议签署日期
    ,nvl(n.ectdt, o.ectdt) as ectdt -- 生效日期
    ,nvl(n.paypersna, o.paypersna) as paypersna -- 缴费人名称
    ,nvl(n.paypersidtp, o.paypersidtp) as paypersidtp -- 缴费人证件类型
    ,nvl(n.paypersid, o.paypersid) as paypersid -- 缴费人证件号码
    ,nvl(n.tel, o.tel) as tel -- 联系电话(预留手机号码)
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.remark, o.remark) as remark -- 备注/附言
    ,nvl(n.authmodel, o.authmodel) as authmodel -- 授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）
    ,nvl(n.timeunit, o.timeunit) as timeunit -- 扣款时间单位
    ,nvl(n.timestep, o.timestep) as timestep -- 扣款时间步长
    ,nvl(n.timedesc, o.timedesc) as timedesc -- 扣款时间描述
    ,nvl(n.moneylimit, o.moneylimit) as moneylimit -- 扣款周期内扣费限额
    ,nvl(n.authcode, o.authcode) as authcode -- 手机动态码
    ,nvl(n.status, o.status) as status -- 签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝
    ,nvl(n.errmsg, o.errmsg) as errmsg -- 错误信息
    ,nvl(n.dealinfo, o.dealinfo) as dealinfo -- 中心处理说明
    ,nvl(n.authtlr, o.authtlr) as authtlr -- 授权柜员
    ,nvl(n.authdt, o.authdt) as authdt -- 授权日期
    ,nvl(n.authseqno, o.authseqno) as authseqno -- 授权流水号
    ,nvl(n.authpmtid, o.authpmtid) as authpmtid -- 授权协议号
    ,nvl(n.sendmsgflag, o.sendmsgflag) as sendmsgflag -- 发送短信标识 0-未发送  1-已发送
    ,nvl(n.otpseqno, o.otpseqno) as otpseqno -- 短信验证码验证流水
    ,nvl(n.uptm, o.uptm) as uptm -- 更新时间
    ,nvl(n.authchl, o.authchl) as authchl -- 授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)
    ,nvl(n.margbrn, o.margbrn) as margbrn -- 处理机构(一般开户行)
    ,nvl(n.openbrnnm, o.openbrnnm) as openbrnnm -- 开户机构名称(账户查询)
    ,nvl(n.uptransdt, o.uptransdt) as uptransdt -- 协议变更申请日期
    ,nvl(n.uptranstm, o.uptranstm) as uptranstm -- 协议变更申请时间
    ,nvl(n.upreqid, o.upreqid) as upreqid -- 协议变更申请号
    ,nvl(n.upctrctduedt, o.upctrctduedt) as upctrctduedt -- 协议变更申请的协议到期日
    ,nvl(n.upauthmodel, o.upauthmodel) as upauthmodel -- 协议变更授权模式
    ,nvl(n.upotpseqno, o.upotpseqno) as upotpseqno -- 协议变更短信验证流水
    ,nvl(n.upstatus, o.upstatus) as upstatus -- 协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败
    ,nvl(n.uperrmsg, o.uperrmsg) as uperrmsg -- 协议变更错误信息
    ,nvl(n.upauthdt, o.upauthdt) as upauthdt -- 协议变更授权日期
    ,nvl(n.upauthseqno, o.upauthseqno) as upauthseqno -- 协议授权流水号
    ,nvl(n.upauthtlr, o.upauthtlr) as upauthtlr -- 协议变更授权柜员
    ,nvl(n.upauthchl, o.upauthchl) as upauthchl -- 协议变更授权渠道
    ,case when
            n.corprtnid is null
            and n.pmtid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.corprtnid is null
            and n.pmtid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.corprtnid is null
            and n.pmtid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a68tcontractinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a68tcontractinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.corprtnid = n.corprtnid
            and o.pmtid = n.pmtid
where (
        o.corprtnid is null
        and o.pmtid is null
    )
    or (
        n.corprtnid is null
        and n.pmtid is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.reqid <> n.reqid
        or o.pmtitmcd <> n.pmtitmcd
        or o.pmtitmnm <> n.pmtitmnm
        or o.cstmrid <> n.cstmrid
        or o.cstmrnm <> n.cstmrnm
        or o.issr <> n.issr
        or o.issrnm <> n.issrnm
        or o.accttype <> n.accttype
        or o.acctid <> n.acctid
        or o.ccy <> n.ccy
        or o.oncddctnlmt <> n.oncddctnlmt
        or o.cycddctnnumlmt <> n.cycddctnnumlmt
        or o.ctrctduedt <> n.ctrctduedt
        or o.ctrctsgndt <> n.ctrctsgndt
        or o.ectdt <> n.ectdt
        or o.paypersna <> n.paypersna
        or o.paypersidtp <> n.paypersidtp
        or o.paypersid <> n.paypersid
        or o.tel <> n.tel
        or o.address <> n.address
        or o.remark <> n.remark
        or o.authmodel <> n.authmodel
        or o.timeunit <> n.timeunit
        or o.timestep <> n.timestep
        or o.timedesc <> n.timedesc
        or o.moneylimit <> n.moneylimit
        or o.authcode <> n.authcode
        or o.status <> n.status
        or o.errmsg <> n.errmsg
        or o.dealinfo <> n.dealinfo
        or o.authtlr <> n.authtlr
        or o.authdt <> n.authdt
        or o.authseqno <> n.authseqno
        or o.authpmtid <> n.authpmtid
        or o.sendmsgflag <> n.sendmsgflag
        or o.otpseqno <> n.otpseqno
        or o.uptm <> n.uptm
        or o.authchl <> n.authchl
        or o.margbrn <> n.margbrn
        or o.openbrnnm <> n.openbrnnm
        or o.uptransdt <> n.uptransdt
        or o.uptranstm <> n.uptranstm
        or o.upreqid <> n.upreqid
        or o.upctrctduedt <> n.upctrctduedt
        or o.upauthmodel <> n.upauthmodel
        or o.upotpseqno <> n.upotpseqno
        or o.upstatus <> n.upstatus
        or o.uperrmsg <> n.uperrmsg
        or o.upauthdt <> n.upauthdt
        or o.upauthseqno <> n.upauthseqno
        or o.upauthtlr <> n.upauthtlr
        or o.upauthchl <> n.upauthchl
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a68tcontractinfo_cl(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,corprtnid -- 收付费企业代码
            ,pmtid -- 协议号
            ,reqid -- 申请号
            ,pmtitmcd -- 费项列表
            ,pmtitmnm -- 费项代码说明
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,issr -- 开户行行号
            ,issrnm -- 开户行名称
            ,accttype -- 账户类型
            ,acctid -- 账号/卡号
            ,ccy -- 币种
            ,oncddctnlmt -- 一次扣费限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,ctrctduedt -- 协议到期日期
            ,ctrctsgndt -- 协议签署日期
            ,ectdt -- 生效日期
            ,paypersna -- 缴费人名称
            ,paypersidtp -- 缴费人证件类型
            ,paypersid -- 缴费人证件号码
            ,tel -- 联系电话(预留手机号码)
            ,address -- 地址
            ,remark -- 备注/附言
            ,authmodel -- 授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）
            ,timeunit -- 扣款时间单位
            ,timestep -- 扣款时间步长
            ,timedesc -- 扣款时间描述
            ,moneylimit -- 扣款周期内扣费限额
            ,authcode -- 手机动态码
            ,status -- 签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝
            ,errmsg -- 错误信息
            ,dealinfo -- 中心处理说明
            ,authtlr -- 授权柜员
            ,authdt -- 授权日期
            ,authseqno -- 授权流水号
            ,authpmtid -- 授权协议号
            ,sendmsgflag -- 发送短信标识 0-未发送  1-已发送
            ,otpseqno -- 短信验证码验证流水
            ,uptm -- 更新时间
            ,authchl -- 授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)
            ,margbrn -- 处理机构(一般开户行)
            ,openbrnnm -- 开户机构名称(账户查询)
            ,uptransdt -- 协议变更申请日期
            ,uptranstm -- 协议变更申请时间
            ,upreqid -- 协议变更申请号
            ,upctrctduedt -- 协议变更申请的协议到期日
            ,upauthmodel -- 协议变更授权模式
            ,upotpseqno -- 协议变更短信验证流水
            ,upstatus -- 协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败
            ,uperrmsg -- 协议变更错误信息
            ,upauthdt -- 协议变更授权日期
            ,upauthseqno -- 协议授权流水号
            ,upauthtlr -- 协议变更授权柜员
            ,upauthchl -- 协议变更授权渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a68tcontractinfo_op(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,corprtnid -- 收付费企业代码
            ,pmtid -- 协议号
            ,reqid -- 申请号
            ,pmtitmcd -- 费项列表
            ,pmtitmnm -- 费项代码说明
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,issr -- 开户行行号
            ,issrnm -- 开户行名称
            ,accttype -- 账户类型
            ,acctid -- 账号/卡号
            ,ccy -- 币种
            ,oncddctnlmt -- 一次扣费限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,ctrctduedt -- 协议到期日期
            ,ctrctsgndt -- 协议签署日期
            ,ectdt -- 生效日期
            ,paypersna -- 缴费人名称
            ,paypersidtp -- 缴费人证件类型
            ,paypersid -- 缴费人证件号码
            ,tel -- 联系电话(预留手机号码)
            ,address -- 地址
            ,remark -- 备注/附言
            ,authmodel -- 授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）
            ,timeunit -- 扣款时间单位
            ,timestep -- 扣款时间步长
            ,timedesc -- 扣款时间描述
            ,moneylimit -- 扣款周期内扣费限额
            ,authcode -- 手机动态码
            ,status -- 签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝
            ,errmsg -- 错误信息
            ,dealinfo -- 中心处理说明
            ,authtlr -- 授权柜员
            ,authdt -- 授权日期
            ,authseqno -- 授权流水号
            ,authpmtid -- 授权协议号
            ,sendmsgflag -- 发送短信标识 0-未发送  1-已发送
            ,otpseqno -- 短信验证码验证流水
            ,uptm -- 更新时间
            ,authchl -- 授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)
            ,margbrn -- 处理机构(一般开户行)
            ,openbrnnm -- 开户机构名称(账户查询)
            ,uptransdt -- 协议变更申请日期
            ,uptranstm -- 协议变更申请时间
            ,upreqid -- 协议变更申请号
            ,upctrctduedt -- 协议变更申请的协议到期日
            ,upauthmodel -- 协议变更授权模式
            ,upotpseqno -- 协议变更短信验证流水
            ,upstatus -- 协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败
            ,uperrmsg -- 协议变更错误信息
            ,upauthdt -- 协议变更授权日期
            ,upauthseqno -- 协议授权流水号
            ,upauthtlr -- 协议变更授权柜员
            ,upauthchl -- 协议变更授权渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transdt -- 交易日期
    ,o.transtm -- 交易时间
    ,o.corprtnid -- 收付费企业代码
    ,o.pmtid -- 协议号
    ,o.reqid -- 申请号
    ,o.pmtitmcd -- 费项列表
    ,o.pmtitmnm -- 费项代码说明
    ,o.cstmrid -- 客户号
    ,o.cstmrnm -- 客户名称
    ,o.issr -- 开户行行号
    ,o.issrnm -- 开户行名称
    ,o.accttype -- 账户类型
    ,o.acctid -- 账号/卡号
    ,o.ccy -- 币种
    ,o.oncddctnlmt -- 一次扣费限额
    ,o.cycddctnnumlmt -- 扣款周期内限制笔数
    ,o.ctrctduedt -- 协议到期日期
    ,o.ctrctsgndt -- 协议签署日期
    ,o.ectdt -- 生效日期
    ,o.paypersna -- 缴费人名称
    ,o.paypersidtp -- 缴费人证件类型
    ,o.paypersid -- 缴费人证件号码
    ,o.tel -- 联系电话(预留手机号码)
    ,o.address -- 地址
    ,o.remark -- 备注/附言
    ,o.authmodel -- 授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）
    ,o.timeunit -- 扣款时间单位
    ,o.timestep -- 扣款时间步长
    ,o.timedesc -- 扣款时间描述
    ,o.moneylimit -- 扣款周期内扣费限额
    ,o.authcode -- 手机动态码
    ,o.status -- 签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝
    ,o.errmsg -- 错误信息
    ,o.dealinfo -- 中心处理说明
    ,o.authtlr -- 授权柜员
    ,o.authdt -- 授权日期
    ,o.authseqno -- 授权流水号
    ,o.authpmtid -- 授权协议号
    ,o.sendmsgflag -- 发送短信标识 0-未发送  1-已发送
    ,o.otpseqno -- 短信验证码验证流水
    ,o.uptm -- 更新时间
    ,o.authchl -- 授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)
    ,o.margbrn -- 处理机构(一般开户行)
    ,o.openbrnnm -- 开户机构名称(账户查询)
    ,o.uptransdt -- 协议变更申请日期
    ,o.uptranstm -- 协议变更申请时间
    ,o.upreqid -- 协议变更申请号
    ,o.upctrctduedt -- 协议变更申请的协议到期日
    ,o.upauthmodel -- 协议变更授权模式
    ,o.upotpseqno -- 协议变更短信验证流水
    ,o.upstatus -- 协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败
    ,o.uperrmsg -- 协议变更错误信息
    ,o.upauthdt -- 协议变更授权日期
    ,o.upauthseqno -- 协议授权流水号
    ,o.upauthtlr -- 协议变更授权柜员
    ,o.upauthchl -- 协议变更授权渠道
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
from ${iol_schema}.mpcs_a68tcontractinfo_bk o
    left join ${iol_schema}.mpcs_a68tcontractinfo_op n
        on
            o.corprtnid = n.corprtnid
            and o.pmtid = n.pmtid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a68tcontractinfo_cl d
        on
            o.corprtnid = d.corprtnid
            and o.pmtid = d.pmtid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a68tcontractinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a68tcontractinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a68tcontractinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a68tcontractinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a68tcontractinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a68tcontractinfo_cl;
alter table ${iol_schema}.mpcs_a68tcontractinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a68tcontractinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a68tcontractinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a68tcontractinfo_op purge;
drop table ${iol_schema}.mpcs_a68tcontractinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a68tcontractinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a68tcontractinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
