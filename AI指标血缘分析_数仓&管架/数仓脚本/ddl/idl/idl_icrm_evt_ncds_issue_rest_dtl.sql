/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_evt_ncds_issue_rest_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_evt_ncds_issue_rest_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_evt_ncds_issue_rest_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_evt_ncds_issue_rest_dtl(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_odd_no varchar2(60) -- 交易单号
    ,sub_tran_odd_no varchar2(60) -- 子交易单号
    ,dep_rcpt_cd varchar2(30) -- 存单代码
    ,dep_rcpt_asset_type_cd varchar2(30) -- 存单资产类型代码
    ,dep_rcpt_market_type_cd varchar2(30) -- 存单市场类型代码
    ,issue_way_cd varchar2(10) -- 发行方式代码
    ,subscr_ps_id varchar2(60) -- 认购人ID
    ,subscr_ps_name varchar2(100) -- 认购人名称
    ,bid_price number(30,2) -- 投标价位(元)
    ,bid_qtty number(30,2) -- 投标量(亿元)
    ,hit_bid_price number(30,2) -- 中标价位(元)
    ,hit_bid_qtty number(30,2) -- 中标量(亿元)
    ,subscr_tm varchar2(20) -- 认购时间
    ,submit_user varchar2(60) -- 提交用户
    ,actl_subscr_qtty number(38,8) -- 实际认购量
    ,remark varchar2(250) -- 备注
    ,sell_org varchar2(100) -- 销售机构
    ,fee_calc_rule_cd varchar2(250) -- 费用计算规则代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_evt_ncds_issue_rest_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_evt_ncds_issue_rest_dtl is '同业存单发行结果明细表';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.evt_id is '事件编号';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.tran_odd_no is '交易单号';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.sub_tran_odd_no is '子交易单号';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.dep_rcpt_cd is '存单代码';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.dep_rcpt_asset_type_cd is '存单资产类型代码';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.dep_rcpt_market_type_cd is '存单市场类型代码';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.issue_way_cd is '发行方式代码';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.subscr_ps_id is '认购人ID';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.subscr_ps_name is '认购人名称';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.bid_price is '投标价位(元)';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.bid_qtty is '投标量(亿元)';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.hit_bid_price is '中标价位(元)';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.hit_bid_qtty is '中标量(亿元)';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.subscr_tm is '认购时间';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.submit_user is '提交用户';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.actl_subscr_qtty is '实际认购量';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.remark is '备注';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.sell_org is '销售机构';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.fee_calc_rule_cd is '费用计算规则代码';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_evt_ncds_issue_rest_dtl.etl_timestamp is '数据处理时间';
