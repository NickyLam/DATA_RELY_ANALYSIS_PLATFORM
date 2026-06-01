/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0jtpmisaddghfxseinfo
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
create table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo where 0=1;

create table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,businesstrace -- 行内业务序号
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,purfx_type_code -- 购汇资金属性代码
            ,txccy -- 币种
            ,purfx_amt -- 购汇金额
            ,purfx_cash_amt -- 购汇提钞金额
            ,fcy_remit_amt -- 汇出资金（包括外汇票据）金额
            ,fcy_acct_amt -- 存入个人外汇账户金额
            ,tchk_amt -- 旅行支票金额
            ,purfx_acct_cny -- 购汇人民币账户
            ,lcy_acct_no -- 个人外汇账户账号
            ,biz_tx_chnl_code -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
            ,agent_corp_code -- 代理企业组织机构代码
            ,agent_corp_name -- 代理企业名称
            ,indiv_org_code -- 个体工商户组织机构代码
            ,indiv_org_name -- 个体工商户名称
            ,pay_org_code -- 支付机构组织机构代码
            ,capitalno -- 外汇局批件号/备案表号/业务编号
            ,biz_tx_time -- 业务办理时间
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,remark -- 备注
            ,refno -- 业务参号
            ,ret_bank_self_num -- 回执银行自身流水号
            ,purfx_amt_usd -- 本次购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码
            ,code -- 代码
            ,detail -- 错误详细信息
            ,pckheadsrc -- 发起节点代码
            ,pckheaddes -- 接收节点代码
            ,pckheadsendtime -- 发送时间
            ,pckheadcommon_org_code -- 机构代码
            ,pckheadmsgno -- 报文参考号
            ,transmessage -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,edit_reason_code -- 
            ,edit_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,businesstrace -- 行内业务序号
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,purfx_type_code -- 购汇资金属性代码
            ,txccy -- 币种
            ,purfx_amt -- 购汇金额
            ,purfx_cash_amt -- 购汇提钞金额
            ,fcy_remit_amt -- 汇出资金（包括外汇票据）金额
            ,fcy_acct_amt -- 存入个人外汇账户金额
            ,tchk_amt -- 旅行支票金额
            ,purfx_acct_cny -- 购汇人民币账户
            ,lcy_acct_no -- 个人外汇账户账号
            ,biz_tx_chnl_code -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
            ,agent_corp_code -- 代理企业组织机构代码
            ,agent_corp_name -- 代理企业名称
            ,indiv_org_code -- 个体工商户组织机构代码
            ,indiv_org_name -- 个体工商户名称
            ,pay_org_code -- 支付机构组织机构代码
            ,capitalno -- 外汇局批件号/备案表号/业务编号
            ,biz_tx_time -- 业务办理时间
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,remark -- 备注
            ,refno -- 业务参号
            ,ret_bank_self_num -- 回执银行自身流水号
            ,purfx_amt_usd -- 本次购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码
            ,code -- 代码
            ,detail -- 错误详细信息
            ,pckheadsrc -- 发起节点代码
            ,pckheaddes -- 接收节点代码
            ,pckheadsendtime -- 发送时间
            ,pckheadcommon_org_code -- 机构代码
            ,pckheadmsgno -- 报文参考号
            ,transmessage -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,edit_reason_code -- 
            ,edit_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mainseq, o.mainseq) as mainseq -- 中台流水号
    ,nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.businesstrace, o.businesstrace) as businesstrace -- 行内业务序号
    ,nvl(n.status, o.status) as status -- 交易状态 Z 初始状态 1 已应答
    ,nvl(n.trantype, o.trantype) as trantype -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
    ,nvl(n.bank_self_num, o.bank_self_num) as bank_self_num -- 银行自身流水号
    ,nvl(n.biz_type_code, o.biz_type_code) as biz_type_code -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
    ,nvl(n.idtype_code, o.idtype_code) as idtype_code -- 证件类型代码
    ,nvl(n.idcode, o.idcode) as idcode -- 证件号码
    ,nvl(n.ctycode, o.ctycode) as ctycode -- 国家/地区代码
    ,nvl(n.add_idcode, o.add_idcode) as add_idcode -- 补充证件号码
    ,nvl(n.person_name, o.person_name) as person_name -- 姓名
    ,nvl(n.purfx_type_code, o.purfx_type_code) as purfx_type_code -- 购汇资金属性代码
    ,nvl(n.txccy, o.txccy) as txccy -- 币种
    ,nvl(n.purfx_amt, o.purfx_amt) as purfx_amt -- 购汇金额
    ,nvl(n.purfx_cash_amt, o.purfx_cash_amt) as purfx_cash_amt -- 购汇提钞金额
    ,nvl(n.fcy_remit_amt, o.fcy_remit_amt) as fcy_remit_amt -- 汇出资金（包括外汇票据）金额
    ,nvl(n.fcy_acct_amt, o.fcy_acct_amt) as fcy_acct_amt -- 存入个人外汇账户金额
    ,nvl(n.tchk_amt, o.tchk_amt) as tchk_amt -- 旅行支票金额
    ,nvl(n.purfx_acct_cny, o.purfx_acct_cny) as purfx_acct_cny -- 购汇人民币账户
    ,nvl(n.lcy_acct_no, o.lcy_acct_no) as lcy_acct_no -- 个人外汇账户账号
    ,nvl(n.biz_tx_chnl_code, o.biz_tx_chnl_code) as biz_tx_chnl_code -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
    ,nvl(n.agent_corp_code, o.agent_corp_code) as agent_corp_code -- 代理企业组织机构代码
    ,nvl(n.agent_corp_name, o.agent_corp_name) as agent_corp_name -- 代理企业名称
    ,nvl(n.indiv_org_code, o.indiv_org_code) as indiv_org_code -- 个体工商户组织机构代码
    ,nvl(n.indiv_org_name, o.indiv_org_name) as indiv_org_name -- 个体工商户名称
    ,nvl(n.pay_org_code, o.pay_org_code) as pay_org_code -- 支付机构组织机构代码
    ,nvl(n.capitalno, o.capitalno) as capitalno -- 外汇局批件号/备案表号/业务编号
    ,nvl(n.biz_tx_time, o.biz_tx_time) as biz_tx_time -- 业务办理时间
    ,nvl(n.rein_reason_code, o.rein_reason_code) as rein_reason_code -- 补录原因代码
    ,nvl(n.rein_remark, o.rein_remark) as rein_remark -- 补录说明
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.refno, o.refno) as refno -- 业务参号
    ,nvl(n.ret_bank_self_num, o.ret_bank_self_num) as ret_bank_self_num -- 回执银行自身流水号
    ,nvl(n.purfx_amt_usd, o.purfx_amt_usd) as purfx_amt_usd -- 本次购汇金额折美元
    ,nvl(n.ann_rem_fcyamt_usd, o.ann_rem_fcyamt_usd) as ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
    ,nvl(n.type_status, o.type_status) as type_status -- 个人主体分类状态代码
    ,nvl(n.pub_date, o.pub_date) as pub_date -- 发布日期
    ,nvl(n.end_date, o.end_date) as end_date -- 到期日期
    ,nvl(n.pub_reason, o.pub_reason) as pub_reason -- 发布原因
    ,nvl(n.pub_code, o.pub_code) as pub_code -- 发布原因代码
    ,nvl(n.code, o.code) as code -- 代码
    ,nvl(n.detail, o.detail) as detail -- 错误详细信息
    ,nvl(n.pckheadsrc, o.pckheadsrc) as pckheadsrc -- 发起节点代码
    ,nvl(n.pckheaddes, o.pckheaddes) as pckheaddes -- 接收节点代码
    ,nvl(n.pckheadsendtime, o.pckheadsendtime) as pckheadsendtime -- 发送时间
    ,nvl(n.pckheadcommon_org_code, o.pckheadcommon_org_code) as pckheadcommon_org_code -- 机构代码
    ,nvl(n.pckheadmsgno, o.pckheadmsgno) as pckheadmsgno -- 报文参考号
    ,nvl(n.transmessage, o.transmessage) as transmessage -- 
    ,nvl(n.srcsysid, o.srcsysid) as srcsysid -- 
    ,nvl(n.srcseqno, o.srcseqno) as srcseqno -- 
    ,nvl(n.edit_reason_code, o.edit_reason_code) as edit_reason_code -- 
    ,nvl(n.edit_remark, o.edit_remark) as edit_remark -- 
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
from (select * from ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0jtpmisaddghfxseinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.businesstrace <> n.businesstrace
        or o.status <> n.status
        or o.trantype <> n.trantype
        or o.bank_self_num <> n.bank_self_num
        or o.biz_type_code <> n.biz_type_code
        or o.idtype_code <> n.idtype_code
        or o.idcode <> n.idcode
        or o.ctycode <> n.ctycode
        or o.add_idcode <> n.add_idcode
        or o.person_name <> n.person_name
        or o.purfx_type_code <> n.purfx_type_code
        or o.txccy <> n.txccy
        or o.purfx_amt <> n.purfx_amt
        or o.purfx_cash_amt <> n.purfx_cash_amt
        or o.fcy_remit_amt <> n.fcy_remit_amt
        or o.fcy_acct_amt <> n.fcy_acct_amt
        or o.tchk_amt <> n.tchk_amt
        or o.purfx_acct_cny <> n.purfx_acct_cny
        or o.lcy_acct_no <> n.lcy_acct_no
        or o.biz_tx_chnl_code <> n.biz_tx_chnl_code
        or o.agent_corp_code <> n.agent_corp_code
        or o.agent_corp_name <> n.agent_corp_name
        or o.indiv_org_code <> n.indiv_org_code
        or o.indiv_org_name <> n.indiv_org_name
        or o.pay_org_code <> n.pay_org_code
        or o.capitalno <> n.capitalno
        or o.biz_tx_time <> n.biz_tx_time
        or o.rein_reason_code <> n.rein_reason_code
        or o.rein_remark <> n.rein_remark
        or o.remark <> n.remark
        or o.refno <> n.refno
        or o.ret_bank_self_num <> n.ret_bank_self_num
        or o.purfx_amt_usd <> n.purfx_amt_usd
        or o.ann_rem_fcyamt_usd <> n.ann_rem_fcyamt_usd
        or o.type_status <> n.type_status
        or o.pub_date <> n.pub_date
        or o.end_date <> n.end_date
        or o.pub_reason <> n.pub_reason
        or o.pub_code <> n.pub_code
        or o.code <> n.code
        or o.detail <> n.detail
        or o.pckheadsrc <> n.pckheadsrc
        or o.pckheaddes <> n.pckheaddes
        or o.pckheadsendtime <> n.pckheadsendtime
        or o.pckheadcommon_org_code <> n.pckheadcommon_org_code
        or o.pckheadmsgno <> n.pckheadmsgno
        or o.transmessage <> n.transmessage
        or o.srcsysid <> n.srcsysid
        or o.srcseqno <> n.srcseqno
        or o.edit_reason_code <> n.edit_reason_code
        or o.edit_remark <> n.edit_remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,businesstrace -- 行内业务序号
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,purfx_type_code -- 购汇资金属性代码
            ,txccy -- 币种
            ,purfx_amt -- 购汇金额
            ,purfx_cash_amt -- 购汇提钞金额
            ,fcy_remit_amt -- 汇出资金（包括外汇票据）金额
            ,fcy_acct_amt -- 存入个人外汇账户金额
            ,tchk_amt -- 旅行支票金额
            ,purfx_acct_cny -- 购汇人民币账户
            ,lcy_acct_no -- 个人外汇账户账号
            ,biz_tx_chnl_code -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
            ,agent_corp_code -- 代理企业组织机构代码
            ,agent_corp_name -- 代理企业名称
            ,indiv_org_code -- 个体工商户组织机构代码
            ,indiv_org_name -- 个体工商户名称
            ,pay_org_code -- 支付机构组织机构代码
            ,capitalno -- 外汇局批件号/备案表号/业务编号
            ,biz_tx_time -- 业务办理时间
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,remark -- 备注
            ,refno -- 业务参号
            ,ret_bank_self_num -- 回执银行自身流水号
            ,purfx_amt_usd -- 本次购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码
            ,code -- 代码
            ,detail -- 错误详细信息
            ,pckheadsrc -- 发起节点代码
            ,pckheaddes -- 接收节点代码
            ,pckheadsendtime -- 发送时间
            ,pckheadcommon_org_code -- 机构代码
            ,pckheadmsgno -- 报文参考号
            ,transmessage -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,edit_reason_code -- 
            ,edit_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,businesstrace -- 行内业务序号
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,purfx_type_code -- 购汇资金属性代码
            ,txccy -- 币种
            ,purfx_amt -- 购汇金额
            ,purfx_cash_amt -- 购汇提钞金额
            ,fcy_remit_amt -- 汇出资金（包括外汇票据）金额
            ,fcy_acct_amt -- 存入个人外汇账户金额
            ,tchk_amt -- 旅行支票金额
            ,purfx_acct_cny -- 购汇人民币账户
            ,lcy_acct_no -- 个人外汇账户账号
            ,biz_tx_chnl_code -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
            ,agent_corp_code -- 代理企业组织机构代码
            ,agent_corp_name -- 代理企业名称
            ,indiv_org_code -- 个体工商户组织机构代码
            ,indiv_org_name -- 个体工商户名称
            ,pay_org_code -- 支付机构组织机构代码
            ,capitalno -- 外汇局批件号/备案表号/业务编号
            ,biz_tx_time -- 业务办理时间
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,remark -- 备注
            ,refno -- 业务参号
            ,ret_bank_self_num -- 回执银行自身流水号
            ,purfx_amt_usd -- 本次购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码
            ,code -- 代码
            ,detail -- 错误详细信息
            ,pckheadsrc -- 发起节点代码
            ,pckheaddes -- 接收节点代码
            ,pckheadsendtime -- 发送时间
            ,pckheadcommon_org_code -- 机构代码
            ,pckheadmsgno -- 报文参考号
            ,transmessage -- 
            ,srcsysid -- 
            ,srcseqno -- 
            ,edit_reason_code -- 
            ,edit_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mainseq -- 中台流水号
    ,o.transdt -- 交易日期
    ,o.businesstrace -- 行内业务序号
    ,o.status -- 交易状态 Z 初始状态 1 已应答
    ,o.trantype -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
    ,o.bank_self_num -- 银行自身流水号
    ,o.biz_type_code -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
    ,o.idtype_code -- 证件类型代码
    ,o.idcode -- 证件号码
    ,o.ctycode -- 国家/地区代码
    ,o.add_idcode -- 补充证件号码
    ,o.person_name -- 姓名
    ,o.purfx_type_code -- 购汇资金属性代码
    ,o.txccy -- 币种
    ,o.purfx_amt -- 购汇金额
    ,o.purfx_cash_amt -- 购汇提钞金额
    ,o.fcy_remit_amt -- 汇出资金（包括外汇票据）金额
    ,o.fcy_acct_amt -- 存入个人外汇账户金额
    ,o.tchk_amt -- 旅行支票金额
    ,o.purfx_acct_cny -- 购汇人民币账户
    ,o.lcy_acct_no -- 个人外汇账户账号
    ,o.biz_tx_chnl_code -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
    ,o.agent_corp_code -- 代理企业组织机构代码
    ,o.agent_corp_name -- 代理企业名称
    ,o.indiv_org_code -- 个体工商户组织机构代码
    ,o.indiv_org_name -- 个体工商户名称
    ,o.pay_org_code -- 支付机构组织机构代码
    ,o.capitalno -- 外汇局批件号/备案表号/业务编号
    ,o.biz_tx_time -- 业务办理时间
    ,o.rein_reason_code -- 补录原因代码
    ,o.rein_remark -- 补录说明
    ,o.remark -- 备注
    ,o.refno -- 业务参号
    ,o.ret_bank_self_num -- 回执银行自身流水号
    ,o.purfx_amt_usd -- 本次购汇金额折美元
    ,o.ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
    ,o.type_status -- 个人主体分类状态代码
    ,o.pub_date -- 发布日期
    ,o.end_date -- 到期日期
    ,o.pub_reason -- 发布原因
    ,o.pub_code -- 发布原因代码
    ,o.code -- 代码
    ,o.detail -- 错误详细信息
    ,o.pckheadsrc -- 发起节点代码
    ,o.pckheaddes -- 接收节点代码
    ,o.pckheadsendtime -- 发送时间
    ,o.pckheadcommon_org_code -- 机构代码
    ,o.pckheadmsgno -- 报文参考号
    ,o.transmessage -- 
    ,o.srcsysid -- 
    ,o.srcseqno -- 
    ,o.edit_reason_code -- 
    ,o.edit_remark -- 
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
from ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_bk o
    left join ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_op n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_cl d
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
--truncate table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0jtpmisaddghfxseinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_cl;
alter table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0jtpmisaddghfxseinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
