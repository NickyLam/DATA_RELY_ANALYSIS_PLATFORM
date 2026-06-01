/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_provision
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_provision
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_provision purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_provision(
    prov_id varchar2(60) -- 计提主表ID
    ,top_branch_no varchar2(60) -- 所属总行机构号
    ,busi_branch_no varchar2(18) -- 交易机构编号
    ,contract_id varchar2(60) -- 协议ID
    ,detail_id varchar2(60) -- 业务明细ID
    ,draft_id varchar2(60) -- 票据ID
    ,draft_number varchar2(45) -- 票据号
    ,draft_type varchar2(6) -- 票据类型： 1 银票 2 商票
    ,product_no varchar2(23) -- 业务产品号
    ,interest number(18,2) -- 利息
    ,it_in_subject_no varchar2(150) -- 利息收入科目
    ,it_back_subject_no varchar2(150) -- 计提后科目
    ,it_sale_subject_no varchar2(150) -- 卖断后科目
    ,start_dt_ora varchar2(12) -- 计提开始日
    ,end_dt_ora varchar2(12) -- 结束计提日
    ,real_enddt varchar2(12) -- 实际结束计提日
    ,jiti_dt varchar2(12) -- 计提日
    ,payment_date varchar2(12) -- 计息到期日
    ,payment_days number(22,0) -- 计息天数
    ,prov_interest number(18,2) -- 已计提利息
    ,rema_interest number(18,2) -- 剩余利息
    ,ever_pro_amount number(18,2) -- 每日记提金额
    ,sale_run_interest number(18,2) -- 卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的
    ,sale_detail_id varchar2(60) -- 卖断时关联业务明细ID
    ,jiti_type varchar2(60) -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,status varchar2(3) -- 计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束
    ,err_flag varchar2(3) -- 计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）
    ,create_time timestamp -- 创建时间
    ,reserve1 varchar2(150) -- 保留字段1
    ,reserve2 varchar2(150) -- 保留字段2
    ,reserve3 varchar2(150) -- 保留字段3
    ,sele_prono varchar2(23) -- 卖出产品号
    ,buy_protocol_no varchar2(60) -- 买入协议号
    ,sale_contract_id varchar2(60) -- 卖出协议ID
    ,sale_protocol_no varchar2(60) -- 卖出协议号
    ,update_time timestamp -- 更新时间
    ,acct_branch_no varchar2(30) -- 账务机构号
    ,draft_attr varchar2(2) -- 
    ,cd_range varchar2(38) -- 子票区间
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,sale_draft_id varchar2(60) -- 结束的票据ID
    ,sale_cd_range varchar2(38) -- 结束的子票区间
    ,bms_draft_id varchar2(60) -- 原票据系统的登记中心ID
    ,settle_status varchar2(6) -- 结算状态
    ,sale_amount number(18,2) -- 结束金额
    ,draft_amount number(18,2) -- 票面金额
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
grant select on ${iol_schema}.bdms_bms_provision to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_provision to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_provision to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_provision to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_provision is '计提主表';
comment on column ${iol_schema}.bdms_bms_provision.prov_id is '计提主表ID';
comment on column ${iol_schema}.bdms_bms_provision.top_branch_no is '所属总行机构号';
comment on column ${iol_schema}.bdms_bms_provision.busi_branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_bms_provision.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_bms_provision.detail_id is '业务明细ID';
comment on column ${iol_schema}.bdms_bms_provision.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_provision.draft_number is '票据号';
comment on column ${iol_schema}.bdms_bms_provision.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_provision.product_no is '业务产品号';
comment on column ${iol_schema}.bdms_bms_provision.interest is '利息';
comment on column ${iol_schema}.bdms_bms_provision.it_in_subject_no is '利息收入科目';
comment on column ${iol_schema}.bdms_bms_provision.it_back_subject_no is '计提后科目';
comment on column ${iol_schema}.bdms_bms_provision.it_sale_subject_no is '卖断后科目';
comment on column ${iol_schema}.bdms_bms_provision.start_dt_ora is '计提开始日';
comment on column ${iol_schema}.bdms_bms_provision.end_dt_ora is '结束计提日';
comment on column ${iol_schema}.bdms_bms_provision.real_enddt is '实际结束计提日';
comment on column ${iol_schema}.bdms_bms_provision.jiti_dt is '计提日';
comment on column ${iol_schema}.bdms_bms_provision.payment_date is '计息到期日';
comment on column ${iol_schema}.bdms_bms_provision.payment_days is '计息天数';
comment on column ${iol_schema}.bdms_bms_provision.prov_interest is '已计提利息';
comment on column ${iol_schema}.bdms_bms_provision.rema_interest is '剩余利息';
comment on column ${iol_schema}.bdms_bms_provision.ever_pro_amount is '每日记提金额';
comment on column ${iol_schema}.bdms_bms_provision.sale_run_interest is '卖断转移利息=未摊销利息-支出利息，即钆差后的值，钆差后可能是正，也可能是负，存的卖断后科目也是不同的';
comment on column ${iol_schema}.bdms_bms_provision.sale_detail_id is '卖断时关联业务明细ID';
comment on column ${iol_schema}.bdms_bms_provision.jiti_type is '计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购';
comment on column ${iol_schema}.bdms_bms_provision.status is '计提状态： 0 初始化 1 计提准备 2 计提过程 3 计提结束 4 卖断计提结束';
comment on column ${iol_schema}.bdms_bms_provision.err_flag is '计提异常标志： 0 正常 1 漏提（中间某日未提） 2 多提（计提出现负利息）';
comment on column ${iol_schema}.bdms_bms_provision.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_provision.reserve1 is '保留字段1';
comment on column ${iol_schema}.bdms_bms_provision.reserve2 is '保留字段2';
comment on column ${iol_schema}.bdms_bms_provision.reserve3 is '保留字段3';
comment on column ${iol_schema}.bdms_bms_provision.sele_prono is '卖出产品号';
comment on column ${iol_schema}.bdms_bms_provision.buy_protocol_no is '买入协议号';
comment on column ${iol_schema}.bdms_bms_provision.sale_contract_id is '卖出协议ID';
comment on column ${iol_schema}.bdms_bms_provision.sale_protocol_no is '卖出协议号';
comment on column ${iol_schema}.bdms_bms_provision.update_time is '更新时间';
comment on column ${iol_schema}.bdms_bms_provision.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_bms_provision.draft_attr is '';
comment on column ${iol_schema}.bdms_bms_provision.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_bms_provision.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_provision.sale_draft_id is '结束的票据ID';
comment on column ${iol_schema}.bdms_bms_provision.sale_cd_range is '结束的子票区间';
comment on column ${iol_schema}.bdms_bms_provision.bms_draft_id is '原票据系统的登记中心ID';
comment on column ${iol_schema}.bdms_bms_provision.settle_status is '结算状态';
comment on column ${iol_schema}.bdms_bms_provision.sale_amount is '结束金额';
comment on column ${iol_schema}.bdms_bms_provision.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_bms_provision.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_provision.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_provision.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_provision.etl_timestamp is 'ETL处理时间戳';
