/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_acct_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_acct_history
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_acct_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_acct_history(
    ah_id varchar2(60) -- 余额ID
    ,top_branch_no varchar2(60) -- 所属总行机构号
    ,busi_branch_no varchar2(30) -- 交易机构号
    ,contract_id varchar2(60) -- 协议ID
    ,detail_id varchar2(60) -- 业务明细ID
    ,draft_id varchar2(60) -- 票据ID
    ,draft_number varchar2(45) -- 票据号
    ,draft_amount number(18,2) -- 票面金额
    ,draft_type varchar2(6) -- 票据种类： 1 银票 2 商票
    ,subject_no varchar2(45) -- 科目号
    ,subject_name varchar2(150) -- 科目名称
    ,dr_cr varchar2(3) -- 借贷标志 D:借 C:贷
    ,cust_no varchar2(45) -- 客户号
    ,cust_name varchar2(375) -- 客户名称
    ,product_no varchar2(23) -- 业务产品号
    ,sele_prono varchar2(23) -- 买出产品号
    ,start_dt_ora varchar2(12) -- 开始日期
    ,end_dt_ora varchar2(12) -- 结束日期--卖出，托收
    ,status varchar2(3) -- 状态： 0 初始化 1 开始 2 结束
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,reserve1 varchar2(150) -- 保留字段1
    ,reserve2 varchar2(150) -- 保留字段2
    ,reserve3 varchar2(150) -- 保留字段3
    ,sale_detail_id varchar2(60) -- 卖断时关联业务明细ID
    ,buy_protocol_no varchar2(60) -- 买入协议号
    ,sale_contract_id varchar2(60) -- 卖出协议ID
    ,sale_protocol_no varchar2(60) -- 卖出协议号
    ,acct_branch_no varchar2(30) -- 账务机构号
    ,jiti_type varchar2(15) -- 计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,cd_range varchar2(38) -- 子票区间
    ,sale_draft_id varchar2(60) -- 结束的票据ID
    ,sale_cd_range varchar2(38) -- 结束的子票区间
    ,bms_draft_id varchar2(60) -- 原票据系统的登记中心ID
    ,settle_status varchar2(6) -- 结算状态
    ,sale_amount number(18,2) -- 结束金额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_bms_acct_history to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_acct_history to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_acct_history to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_acct_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_acct_history is '余额表';
comment on column ${iol_schema}.bdms_bms_acct_history.ah_id is '余额ID';
comment on column ${iol_schema}.bdms_bms_acct_history.top_branch_no is '所属总行机构号';
comment on column ${iol_schema}.bdms_bms_acct_history.busi_branch_no is '交易机构号';
comment on column ${iol_schema}.bdms_bms_acct_history.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_bms_acct_history.detail_id is '业务明细ID';
comment on column ${iol_schema}.bdms_bms_acct_history.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_acct_history.draft_number is '票据号';
comment on column ${iol_schema}.bdms_bms_acct_history.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_bms_acct_history.draft_type is '票据种类： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_acct_history.subject_no is '科目号';
comment on column ${iol_schema}.bdms_bms_acct_history.subject_name is '科目名称';
comment on column ${iol_schema}.bdms_bms_acct_history.dr_cr is '借贷标志 D:借 C:贷';
comment on column ${iol_schema}.bdms_bms_acct_history.cust_no is '客户号';
comment on column ${iol_schema}.bdms_bms_acct_history.cust_name is '客户名称';
comment on column ${iol_schema}.bdms_bms_acct_history.product_no is '业务产品号';
comment on column ${iol_schema}.bdms_bms_acct_history.sele_prono is '买出产品号';
comment on column ${iol_schema}.bdms_bms_acct_history.start_dt_ora is '开始日期';
comment on column ${iol_schema}.bdms_bms_acct_history.end_dt_ora is '结束日期--卖出，托收';
comment on column ${iol_schema}.bdms_bms_acct_history.status is '状态： 0 初始化 1 开始 2 结束';
comment on column ${iol_schema}.bdms_bms_acct_history.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_acct_history.update_time is '更新时间';
comment on column ${iol_schema}.bdms_bms_acct_history.reserve1 is '保留字段1';
comment on column ${iol_schema}.bdms_bms_acct_history.reserve2 is '保留字段2';
comment on column ${iol_schema}.bdms_bms_acct_history.reserve3 is '保留字段3';
comment on column ${iol_schema}.bdms_bms_acct_history.sale_detail_id is '卖断时关联业务明细ID';
comment on column ${iol_schema}.bdms_bms_acct_history.buy_protocol_no is '买入协议号';
comment on column ${iol_schema}.bdms_bms_acct_history.sale_contract_id is '卖出协议ID';
comment on column ${iol_schema}.bdms_bms_acct_history.sale_protocol_no is '卖出协议号';
comment on column ${iol_schema}.bdms_bms_acct_history.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_bms_acct_history.jiti_type is '计提类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购';
comment on column ${iol_schema}.bdms_bms_acct_history.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_acct_history.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_bms_acct_history.sale_draft_id is '结束的票据ID';
comment on column ${iol_schema}.bdms_bms_acct_history.sale_cd_range is '结束的子票区间';
comment on column ${iol_schema}.bdms_bms_acct_history.bms_draft_id is '原票据系统的登记中心ID';
comment on column ${iol_schema}.bdms_bms_acct_history.settle_status is '结算状态';
comment on column ${iol_schema}.bdms_bms_acct_history.sale_amount is '结束金额';
comment on column ${iol_schema}.bdms_bms_acct_history.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_acct_history.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_acct_history.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_acct_history.etl_timestamp is 'ETL处理时间戳';
