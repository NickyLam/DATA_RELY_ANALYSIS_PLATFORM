/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ibs_acp_acceptmain_log
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
create table ${iol_schema}.nibs_ibs_acp_acceptmain_log_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ibs_acp_acceptmain_log
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ibs_acp_acceptmain_log_op purge;
drop table ${iol_schema}.nibs_ibs_acp_acceptmain_log_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ibs_acp_acceptmain_log_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ibs_acp_acceptmain_log where 0=1;

create table ${iol_schema}.nibs_ibs_acp_acceptmain_log_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ibs_acp_acceptmain_log where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ibs_acp_acceptmain_log_cl(
            tradeserno -- 预受理编号
            ,oldtradeserno -- 原预受理编号
            ,cardstatus -- 
            ,approve_no -- 订单号(视频审核直接发通知请求时使用)
            ,diff_pla_vide_res -- 开户许可证核准号/基本存款账户编号
            ,acct_leg_res -- 基本户法人意愿核实结果（1-审核通过，0-审核不通过）
            ,apply_type -- 交易类型（2对公单位，1个人）
            ,apply_amt -- 提现金额
            ,apply_ccy -- 币种
            ,biztype -- 业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单
            ,status -- 预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时
            ,busiserno -- 交易流水
            ,channelcode -- 发起渠道
            ,acctno -- 账户编号
            ,acctname -- 户名
            ,custno -- 客户编号
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,idname -- 证件名称
            ,is_porxy -- 是否代理(0-否,1-是)
            ,agentidtype -- 代办人证件类型
            ,agentidno -- 代办人证件号码
            ,agentidname -- 代办人证件名称
            ,agentphone -- 代办人联系方式
            ,remark -- 备注|预审结论
            ,createdate -- 创建日期
            ,createtime -- 创建时间
            ,createby -- 柜员编号
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,updateby -- 柜员编号
            ,reftradeserno -- 流程银行受理流水号
            ,applydate -- 申请日期
            ,applybrno -- 机构编号
            ,phone -- 手机号码
            ,reserv_id -- 预约id
            ,apply_remark -- 提现用途及理由
            ,other_remark -- 其他用途
            ,vouchers -- 券别
            ,vouchers_amt -- 券别金额
            ,lpidnum -- 法人证件号码
            ,lpidtype -- 法人证件类型
            ,lpname -- 法人姓名
            ,certvaliddt -- 证件有效期
            ,esdate -- 成立日
            ,lpcertduedt -- 法定代表人证件有效期
            ,operscope -- 经营范围
            ,prooffileid -- 证明文件编号
            ,regcap -- 注册资金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ibs_acp_acceptmain_log_op(
            tradeserno -- 预受理编号
            ,oldtradeserno -- 原预受理编号
            ,cardstatus -- 
            ,approve_no -- 订单号(视频审核直接发通知请求时使用)
            ,diff_pla_vide_res -- 开户许可证核准号/基本存款账户编号
            ,acct_leg_res -- 基本户法人意愿核实结果（1-审核通过，0-审核不通过）
            ,apply_type -- 交易类型（2对公单位，1个人）
            ,apply_amt -- 提现金额
            ,apply_ccy -- 币种
            ,biztype -- 业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单
            ,status -- 预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时
            ,busiserno -- 交易流水
            ,channelcode -- 发起渠道
            ,acctno -- 账户编号
            ,acctname -- 户名
            ,custno -- 客户编号
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,idname -- 证件名称
            ,is_porxy -- 是否代理(0-否,1-是)
            ,agentidtype -- 代办人证件类型
            ,agentidno -- 代办人证件号码
            ,agentidname -- 代办人证件名称
            ,agentphone -- 代办人联系方式
            ,remark -- 备注|预审结论
            ,createdate -- 创建日期
            ,createtime -- 创建时间
            ,createby -- 柜员编号
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,updateby -- 柜员编号
            ,reftradeserno -- 流程银行受理流水号
            ,applydate -- 申请日期
            ,applybrno -- 机构编号
            ,phone -- 手机号码
            ,reserv_id -- 预约id
            ,apply_remark -- 提现用途及理由
            ,other_remark -- 其他用途
            ,vouchers -- 券别
            ,vouchers_amt -- 券别金额
            ,lpidnum -- 法人证件号码
            ,lpidtype -- 法人证件类型
            ,lpname -- 法人姓名
            ,certvaliddt -- 证件有效期
            ,esdate -- 成立日
            ,lpcertduedt -- 法定代表人证件有效期
            ,operscope -- 经营范围
            ,prooffileid -- 证明文件编号
            ,regcap -- 注册资金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tradeserno, o.tradeserno) as tradeserno -- 预受理编号
    ,nvl(n.oldtradeserno, o.oldtradeserno) as oldtradeserno -- 原预受理编号
    ,nvl(n.cardstatus, o.cardstatus) as cardstatus -- 
    ,nvl(n.approve_no, o.approve_no) as approve_no -- 订单号(视频审核直接发通知请求时使用)
    ,nvl(n.diff_pla_vide_res, o.diff_pla_vide_res) as diff_pla_vide_res -- 开户许可证核准号/基本存款账户编号
    ,nvl(n.acct_leg_res, o.acct_leg_res) as acct_leg_res -- 基本户法人意愿核实结果（1-审核通过，0-审核不通过）
    ,nvl(n.apply_type, o.apply_type) as apply_type -- 交易类型（2对公单位，1个人）
    ,nvl(n.apply_amt, o.apply_amt) as apply_amt -- 提现金额
    ,nvl(n.apply_ccy, o.apply_ccy) as apply_ccy -- 币种
    ,nvl(n.biztype, o.biztype) as biztype -- 业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单
    ,nvl(n.status, o.status) as status -- 预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时
    ,nvl(n.busiserno, o.busiserno) as busiserno -- 交易流水
    ,nvl(n.channelcode, o.channelcode) as channelcode -- 发起渠道
    ,nvl(n.acctno, o.acctno) as acctno -- 账户编号
    ,nvl(n.acctname, o.acctname) as acctname -- 户名
    ,nvl(n.custno, o.custno) as custno -- 客户编号
    ,nvl(n.custname, o.custname) as custname -- 客户名称
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idno, o.idno) as idno -- 证件号码
    ,nvl(n.idname, o.idname) as idname -- 证件名称
    ,nvl(n.is_porxy, o.is_porxy) as is_porxy -- 是否代理(0-否,1-是)
    ,nvl(n.agentidtype, o.agentidtype) as agentidtype -- 代办人证件类型
    ,nvl(n.agentidno, o.agentidno) as agentidno -- 代办人证件号码
    ,nvl(n.agentidname, o.agentidname) as agentidname -- 代办人证件名称
    ,nvl(n.agentphone, o.agentphone) as agentphone -- 代办人联系方式
    ,nvl(n.remark, o.remark) as remark -- 备注|预审结论
    ,nvl(n.createdate, o.createdate) as createdate -- 创建日期
    ,nvl(n.createtime, o.createtime) as createtime -- 创建时间
    ,nvl(n.createby, o.createby) as createby -- 柜员编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.updateby, o.updateby) as updateby -- 柜员编号
    ,nvl(n.reftradeserno, o.reftradeserno) as reftradeserno -- 流程银行受理流水号
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.applybrno, o.applybrno) as applybrno -- 机构编号
    ,nvl(n.phone, o.phone) as phone -- 手机号码
    ,nvl(n.reserv_id, o.reserv_id) as reserv_id -- 预约id
    ,nvl(n.apply_remark, o.apply_remark) as apply_remark -- 提现用途及理由
    ,nvl(n.other_remark, o.other_remark) as other_remark -- 其他用途
    ,nvl(n.vouchers, o.vouchers) as vouchers -- 券别
    ,nvl(n.vouchers_amt, o.vouchers_amt) as vouchers_amt -- 券别金额
    ,nvl(n.lpidnum, o.lpidnum) as lpidnum -- 法人证件号码
    ,nvl(n.lpidtype, o.lpidtype) as lpidtype -- 法人证件类型
    ,nvl(n.lpname, o.lpname) as lpname -- 法人姓名
    ,nvl(n.certvaliddt, o.certvaliddt) as certvaliddt -- 证件有效期
    ,nvl(n.esdate, o.esdate) as esdate -- 成立日
    ,nvl(n.lpcertduedt, o.lpcertduedt) as lpcertduedt -- 法定代表人证件有效期
    ,nvl(n.operscope, o.operscope) as operscope -- 经营范围
    ,nvl(n.prooffileid, o.prooffileid) as prooffileid -- 证明文件编号
    ,nvl(n.regcap, o.regcap) as regcap -- 注册资金
    ,case when
            n.tradeserno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tradeserno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tradeserno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ibs_acp_acceptmain_log_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ibs_acp_acceptmain_log where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tradeserno = n.tradeserno
where (
        o.tradeserno is null
    )
    or (
        n.tradeserno is null
    )
    or (
        o.oldtradeserno <> n.oldtradeserno
        or o.cardstatus <> n.cardstatus
        or o.approve_no <> n.approve_no
        or o.diff_pla_vide_res <> n.diff_pla_vide_res
        or o.acct_leg_res <> n.acct_leg_res
        or o.apply_type <> n.apply_type
        or o.apply_amt <> n.apply_amt
        or o.apply_ccy <> n.apply_ccy
        or o.biztype <> n.biztype
        or o.status <> n.status
        or o.busiserno <> n.busiserno
        or o.channelcode <> n.channelcode
        or o.acctno <> n.acctno
        or o.acctname <> n.acctname
        or o.custno <> n.custno
        or o.custname <> n.custname
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.idname <> n.idname
        or o.is_porxy <> n.is_porxy
        or o.agentidtype <> n.agentidtype
        or o.agentidno <> n.agentidno
        or o.agentidname <> n.agentidname
        or o.agentphone <> n.agentphone
        or o.remark <> n.remark
        or o.createdate <> n.createdate
        or o.createtime <> n.createtime
        or o.createby <> n.createby
        or o.updatedate <> n.updatedate
        or o.updatetime <> n.updatetime
        or o.updateby <> n.updateby
        or o.reftradeserno <> n.reftradeserno
        or o.applydate <> n.applydate
        or o.applybrno <> n.applybrno
        or o.phone <> n.phone
        or o.reserv_id <> n.reserv_id
        or o.apply_remark <> n.apply_remark
        or o.other_remark <> n.other_remark
        or o.vouchers <> n.vouchers
        or o.vouchers_amt <> n.vouchers_amt
        or o.lpidnum <> n.lpidnum
        or o.lpidtype <> n.lpidtype
        or o.lpname <> n.lpname
        or o.certvaliddt <> n.certvaliddt
        or o.esdate <> n.esdate
        or o.lpcertduedt <> n.lpcertduedt
        or o.operscope <> n.operscope
        or o.prooffileid <> n.prooffileid
        or o.regcap <> n.regcap
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ibs_acp_acceptmain_log_cl(
            tradeserno -- 预受理编号
            ,oldtradeserno -- 原预受理编号
            ,cardstatus -- 
            ,approve_no -- 订单号(视频审核直接发通知请求时使用)
            ,diff_pla_vide_res -- 开户许可证核准号/基本存款账户编号
            ,acct_leg_res -- 基本户法人意愿核实结果（1-审核通过，0-审核不通过）
            ,apply_type -- 交易类型（2对公单位，1个人）
            ,apply_amt -- 提现金额
            ,apply_ccy -- 币种
            ,biztype -- 业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单
            ,status -- 预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时
            ,busiserno -- 交易流水
            ,channelcode -- 发起渠道
            ,acctno -- 账户编号
            ,acctname -- 户名
            ,custno -- 客户编号
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,idname -- 证件名称
            ,is_porxy -- 是否代理(0-否,1-是)
            ,agentidtype -- 代办人证件类型
            ,agentidno -- 代办人证件号码
            ,agentidname -- 代办人证件名称
            ,agentphone -- 代办人联系方式
            ,remark -- 备注|预审结论
            ,createdate -- 创建日期
            ,createtime -- 创建时间
            ,createby -- 柜员编号
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,updateby -- 柜员编号
            ,reftradeserno -- 流程银行受理流水号
            ,applydate -- 申请日期
            ,applybrno -- 机构编号
            ,phone -- 手机号码
            ,reserv_id -- 预约id
            ,apply_remark -- 提现用途及理由
            ,other_remark -- 其他用途
            ,vouchers -- 券别
            ,vouchers_amt -- 券别金额
            ,lpidnum -- 法人证件号码
            ,lpidtype -- 法人证件类型
            ,lpname -- 法人姓名
            ,certvaliddt -- 证件有效期
            ,esdate -- 成立日
            ,lpcertduedt -- 法定代表人证件有效期
            ,operscope -- 经营范围
            ,prooffileid -- 证明文件编号
            ,regcap -- 注册资金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ibs_acp_acceptmain_log_op(
            tradeserno -- 预受理编号
            ,oldtradeserno -- 原预受理编号
            ,cardstatus -- 
            ,approve_no -- 订单号(视频审核直接发通知请求时使用)
            ,diff_pla_vide_res -- 开户许可证核准号/基本存款账户编号
            ,acct_leg_res -- 基本户法人意愿核实结果（1-审核通过，0-审核不通过）
            ,apply_type -- 交易类型（2对公单位，1个人）
            ,apply_amt -- 提现金额
            ,apply_ccy -- 币种
            ,biztype -- 业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单
            ,status -- 预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时
            ,busiserno -- 交易流水
            ,channelcode -- 发起渠道
            ,acctno -- 账户编号
            ,acctname -- 户名
            ,custno -- 客户编号
            ,custname -- 客户名称
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,idname -- 证件名称
            ,is_porxy -- 是否代理(0-否,1-是)
            ,agentidtype -- 代办人证件类型
            ,agentidno -- 代办人证件号码
            ,agentidname -- 代办人证件名称
            ,agentphone -- 代办人联系方式
            ,remark -- 备注|预审结论
            ,createdate -- 创建日期
            ,createtime -- 创建时间
            ,createby -- 柜员编号
            ,updatedate -- 更新日期
            ,updatetime -- 更新时间
            ,updateby -- 柜员编号
            ,reftradeserno -- 流程银行受理流水号
            ,applydate -- 申请日期
            ,applybrno -- 机构编号
            ,phone -- 手机号码
            ,reserv_id -- 预约id
            ,apply_remark -- 提现用途及理由
            ,other_remark -- 其他用途
            ,vouchers -- 券别
            ,vouchers_amt -- 券别金额
            ,lpidnum -- 法人证件号码
            ,lpidtype -- 法人证件类型
            ,lpname -- 法人姓名
            ,certvaliddt -- 证件有效期
            ,esdate -- 成立日
            ,lpcertduedt -- 法定代表人证件有效期
            ,operscope -- 经营范围
            ,prooffileid -- 证明文件编号
            ,regcap -- 注册资金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tradeserno -- 预受理编号
    ,o.oldtradeserno -- 原预受理编号
    ,o.cardstatus -- 
    ,o.approve_no -- 订单号(视频审核直接发通知请求时使用)
    ,o.diff_pla_vide_res -- 开户许可证核准号/基本存款账户编号
    ,o.acct_leg_res -- 基本户法人意愿核实结果（1-审核通过，0-审核不通过）
    ,o.apply_type -- 交易类型（2对公单位，1个人）
    ,o.apply_amt -- 提现金额
    ,o.apply_ccy -- 币种
    ,o.biztype -- 业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单
    ,o.status -- 预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时
    ,o.busiserno -- 交易流水
    ,o.channelcode -- 发起渠道
    ,o.acctno -- 账户编号
    ,o.acctname -- 户名
    ,o.custno -- 客户编号
    ,o.custname -- 客户名称
    ,o.idtype -- 证件类型
    ,o.idno -- 证件号码
    ,o.idname -- 证件名称
    ,o.is_porxy -- 是否代理(0-否,1-是)
    ,o.agentidtype -- 代办人证件类型
    ,o.agentidno -- 代办人证件号码
    ,o.agentidname -- 代办人证件名称
    ,o.agentphone -- 代办人联系方式
    ,o.remark -- 备注|预审结论
    ,o.createdate -- 创建日期
    ,o.createtime -- 创建时间
    ,o.createby -- 柜员编号
    ,o.updatedate -- 更新日期
    ,o.updatetime -- 更新时间
    ,o.updateby -- 柜员编号
    ,o.reftradeserno -- 流程银行受理流水号
    ,o.applydate -- 申请日期
    ,o.applybrno -- 机构编号
    ,o.phone -- 手机号码
    ,o.reserv_id -- 预约id
    ,o.apply_remark -- 提现用途及理由
    ,o.other_remark -- 其他用途
    ,o.vouchers -- 券别
    ,o.vouchers_amt -- 券别金额
    ,o.lpidnum -- 法人证件号码
    ,o.lpidtype -- 法人证件类型
    ,o.lpname -- 法人姓名
    ,o.certvaliddt -- 证件有效期
    ,o.esdate -- 成立日
    ,o.lpcertduedt -- 法定代表人证件有效期
    ,o.operscope -- 经营范围
    ,o.prooffileid -- 证明文件编号
    ,o.regcap -- 注册资金
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
from ${iol_schema}.nibs_ibs_acp_acceptmain_log_bk o
    left join ${iol_schema}.nibs_ibs_acp_acceptmain_log_op n
        on
            o.tradeserno = n.tradeserno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ibs_acp_acceptmain_log_cl d
        on
            o.tradeserno = d.tradeserno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ibs_acp_acceptmain_log;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ibs_acp_acceptmain_log') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ibs_acp_acceptmain_log drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ibs_acp_acceptmain_log add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ibs_acp_acceptmain_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_ibs_acp_acceptmain_log_cl;
alter table ${iol_schema}.nibs_ibs_acp_acceptmain_log exchange partition p_20991231 with table ${iol_schema}.nibs_ibs_acp_acceptmain_log_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ibs_acp_acceptmain_log to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ibs_acp_acceptmain_log_op purge;
drop table ${iol_schema}.nibs_ibs_acp_acceptmain_log_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ibs_acp_acceptmain_log_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ibs_acp_acceptmain_log',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
