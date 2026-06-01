/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a0jtpmisaddghfxseinfo
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddghfxseinfo drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddghfxseinfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a0jtpmisaddghfxseinfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a0jtpmisaddghfxseinfo partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainseq  -- 中台流水号
    ,transdt  -- 交易日期
    ,businesstrace  -- 行内业务序号
    ,status  -- 交易状态 Z 初始状态 1 已应答
    ,trantype  -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
    ,bank_self_num  -- 银行自身流水号
    ,biz_type_code  -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
    ,idtype_code  -- 证件类型代码
    ,idcode  -- 证件号码
    ,ctycode  -- 国家/地区代码
    ,add_idcode  -- 补充证件号码
    ,person_name  -- 姓名
    ,purfx_type_code  -- 购汇资金属性代码
    ,txccy  -- 币种
    ,purfx_amt  -- 购汇金额
    ,purfx_cash_amt  -- 购汇提钞金额
    ,fcy_remit_amt  -- 汇出资金（包括外汇票据）金额
    ,fcy_acct_amt  -- 存入个人外汇账户金额
    ,tchk_amt  -- 旅行支票金额
    ,purfx_acct_cny  -- 购汇人民币账户
    ,lcy_acct_no  -- 个人外汇账户账号
    ,biz_tx_chnl_code  -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
    ,agent_corp_code  -- 代理企业组织机构代码
    ,agent_corp_name  -- 代理企业名称
    ,indiv_org_code  -- 个体工商户组织机构代码
    ,indiv_org_name  -- 个体工商户名称
    ,pay_org_code  -- 支付机构组织机构代码
    ,capitalno  -- 外汇局批件号/备案表号/业务编号
    ,biz_tx_time  -- 业务办理时间
    ,rein_reason_code  -- 补录原因代码
    ,rein_remark  -- 补录说明
    ,remark  -- 备注
    ,refno  -- 业务参号
    ,ret_bank_self_num  -- 回执银行自身流水号
    ,purfx_amt_usd  -- 本次购汇金额折美元
    ,ann_rem_fcyamt_usd  -- 本年额度内剩余可购汇金额折美元
    ,type_status  -- 个人主体分类状态代码
    ,pub_date  -- 发布日期
    ,end_date  -- 到期日期
    ,pub_reason  -- 发布原因
    ,pub_code  -- 发布原因代码
    ,code  -- 代码
    ,detail  -- 错误详细信息
    ,pckheadsrc  -- 发起节点代码
    ,pckheaddes  -- 接收节点代码
    ,pckheadsendtime  -- 发送时间
    ,pckheadcommon_org_code  -- 机构代码
    ,pckheadmsgno  -- 报文参考号
    ,transmessage  -- 
    ,srcsysid  -- 
    ,srcseqno  -- 
    ,edit_reason_code  -- 
    ,edit_remark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainseq,chr(13),''),chr(10),'')  -- 中台流水号
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.businesstrace,chr(13),''),chr(10),'')  -- 行内业务序号
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 交易状态 Z 初始状态 1 已应答
    ,replace(replace(t1.trantype,chr(13),''),chr(10),'')  -- 交易类型  ZGL  占额度购汇录入 ZGB  占额度购汇补录 UGL  不占额度购汇录入 UGB  不占额度购汇补录
    ,replace(replace(t1.bank_self_num,chr(13),''),chr(10),'')  -- 银行自身流水号
    ,replace(replace(t1.biz_type_code,chr(13),''),chr(10),'')  -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
    ,replace(replace(t1.idtype_code,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(t1.idcode,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.ctycode,chr(13),''),chr(10),'')  -- 国家/地区代码
    ,replace(replace(t1.add_idcode,chr(13),''),chr(10),'')  -- 补充证件号码
    ,replace(replace(t1.person_name,chr(13),''),chr(10),'')  -- 姓名
    ,replace(replace(t1.purfx_type_code,chr(13),''),chr(10),'')  -- 购汇资金属性代码
    ,replace(replace(t1.txccy,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.purfx_amt,chr(13),''),chr(10),'')  -- 购汇金额
    ,replace(replace(t1.purfx_cash_amt,chr(13),''),chr(10),'')  -- 购汇提钞金额
    ,replace(replace(t1.fcy_remit_amt,chr(13),''),chr(10),'')  -- 汇出资金（包括外汇票据）金额
    ,replace(replace(t1.fcy_acct_amt,chr(13),''),chr(10),'')  -- 存入个人外汇账户金额
    ,replace(replace(t1.tchk_amt,chr(13),''),chr(10),'')  -- 旅行支票金额
    ,replace(replace(t1.purfx_acct_cny,chr(13),''),chr(10),'')  -- 购汇人民币账户
    ,replace(replace(t1.lcy_acct_no,chr(13),''),chr(10),'')  -- 个人外汇账户账号
    ,replace(replace(t1.biz_tx_chnl_code,chr(13),''),chr(10),'')  -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
    ,replace(replace(t1.agent_corp_code,chr(13),''),chr(10),'')  -- 代理企业组织机构代码
    ,replace(replace(t1.agent_corp_name,chr(13),''),chr(10),'')  -- 代理企业名称
    ,replace(replace(t1.indiv_org_code,chr(13),''),chr(10),'')  -- 个体工商户组织机构代码
    ,replace(replace(t1.indiv_org_name,chr(13),''),chr(10),'')  -- 个体工商户名称
    ,replace(replace(t1.pay_org_code,chr(13),''),chr(10),'')  -- 支付机构组织机构代码
    ,replace(replace(t1.capitalno,chr(13),''),chr(10),'')  -- 外汇局批件号/备案表号/业务编号
    ,replace(replace(t1.biz_tx_time,chr(13),''),chr(10),'')  -- 业务办理时间
    ,replace(replace(t1.rein_reason_code,chr(13),''),chr(10),'')  -- 补录原因代码
    ,replace(replace(t1.rein_remark,chr(13),''),chr(10),'')  -- 补录说明
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.refno,chr(13),''),chr(10),'')  -- 业务参号
    ,replace(replace(t1.ret_bank_self_num,chr(13),''),chr(10),'')  -- 回执银行自身流水号
    ,replace(replace(t1.purfx_amt_usd,chr(13),''),chr(10),'')  -- 本次购汇金额折美元
    ,replace(replace(t1.ann_rem_fcyamt_usd,chr(13),''),chr(10),'')  -- 本年额度内剩余可购汇金额折美元
    ,replace(replace(t1.type_status,chr(13),''),chr(10),'')  -- 个人主体分类状态代码
    ,replace(replace(t1.pub_date,chr(13),''),chr(10),'')  -- 发布日期
    ,replace(replace(t1.end_date,chr(13),''),chr(10),'')  -- 到期日期
    ,replace(replace(t1.pub_reason,chr(13),''),chr(10),'')  -- 发布原因
    ,replace(replace(t1.pub_code,chr(13),''),chr(10),'')  -- 发布原因代码
    ,replace(replace(t1.code,chr(13),''),chr(10),'')  -- 代码
    ,replace(replace(t1.detail,chr(13),''),chr(10),'')  -- 错误详细信息
    ,replace(replace(t1.pckheadsrc,chr(13),''),chr(10),'')  -- 发起节点代码
    ,replace(replace(t1.pckheaddes,chr(13),''),chr(10),'')  -- 接收节点代码
    ,replace(replace(t1.pckheadsendtime,chr(13),''),chr(10),'')  -- 发送时间
    ,replace(replace(t1.pckheadcommon_org_code,chr(13),''),chr(10),'')  -- 机构代码
    ,replace(replace(t1.pckheadmsgno,chr(13),''),chr(10),'')  -- 报文参考号
    ,replace(replace(t1.transmessage,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.srcsysid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.srcseqno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.edit_reason_code,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.edit_remark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo t1    --购汇录入补录表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a0jtpmisaddghfxseinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);