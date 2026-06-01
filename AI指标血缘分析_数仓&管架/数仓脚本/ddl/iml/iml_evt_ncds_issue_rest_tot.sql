/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ncds_issue_rest_tot
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ncds_issue_rest_tot
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ncds_issue_rest_tot purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ncds_issue_rest_tot(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_odd_no varchar2(60) -- 交易单号
    ,sub_tran_odd_no varchar2(60) -- 子交易单号
    ,dep_rcpt_cd varchar2(30) -- 存单代码
    ,dep_rcpt_asset_type_cd varchar2(30) -- 存单资产类型代码
    ,dep_rcpt_market_type_cd varchar2(30) -- 存单市场类型代码
    ,issue_way_cd varchar2(10) -- 发行方式代码
    ,subscr_ps_id varchar2(90) -- 认购人ID
    ,subscr_ps_name varchar2(150) -- 认购人名称
    ,bid_price number(38,8) -- 投标价位(元)
    ,bid_qtty number(38,8) -- 投标量(亿元)
    ,hit_bid_price number(38,8) -- 中标价位(元)
    ,hit_bid_qtty number(38,8) -- 中标量(亿元)
    ,subscr_tm timestamp -- 认购时间
    ,submit_user varchar2(90) -- 提交用户
    ,actl_subscr_qtty number(38,8) -- 实际认购量
    ,actl_subscr_ps_name varchar2(4000) -- 实际认购人名称
    ,sell_org_id varchar2(4000) -- 销售机构编号
    ,sell_org_pct_comb varchar2(4000) -- 销售机构占比组合
    ,sell_org_name_comb varchar2(4000) -- 销售机构名称组合
    ,sell_org_pct_comnt varchar2(4000) -- 销售机构占比说明
    ,belong_org_pct_comb varchar2(4000) -- 归属机构占比组合
    ,belong_org_name_comb varchar2(4000) -- 归属机构名称组合
    ,belong_org_pct_comnt varchar2(4000) -- 归属机构占比说明
    ,acvmnt_belong_emply_id varchar2(4000) -- 业绩归属员工编号
    ,acvmnt_belong_hq_emply_id varchar2(4000) -- 业绩归属总行员工编号
    ,pay_amt number(38,8) -- 缴款金额(元)
    ,tran_acct_id varchar2(250) -- 交易账户编号
    ,ghb_open_bank_no varchar2(250) -- 本方开户行行号
    ,fee_calc_rule_cd varchar2(250) -- 费用计算规则代码
    ,remark varchar2(375) -- 备注
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_ncds_issue_rest_tot to ${icl_schema};
grant select on ${iml_schema}.evt_ncds_issue_rest_tot to ${idl_schema};
grant select on ${iml_schema}.evt_ncds_issue_rest_tot to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ncds_issue_rest_tot is '同业存单发行结果汇总表';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.tran_odd_no is '交易单号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.sub_tran_odd_no is '子交易单号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.dep_rcpt_cd is '存单代码';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.dep_rcpt_asset_type_cd is '存单资产类型代码';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.dep_rcpt_market_type_cd is '存单市场类型代码';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.issue_way_cd is '发行方式代码';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.subscr_ps_id is '认购人ID';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.subscr_ps_name is '认购人名称';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.bid_price is '投标价位(元)';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.bid_qtty is '投标量(亿元)';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.hit_bid_price is '中标价位(元)';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.hit_bid_qtty is '中标量(亿元)';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.subscr_tm is '认购时间';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.submit_user is '提交用户';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.actl_subscr_qtty is '实际认购量';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.actl_subscr_ps_name is '实际认购人名称';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.sell_org_id is '销售机构编号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.sell_org_pct_comb is '销售机构占比组合';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.sell_org_name_comb is '销售机构名称组合';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.sell_org_pct_comnt is '销售机构占比说明';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.belong_org_pct_comb is '归属机构占比组合';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.belong_org_name_comb is '归属机构名称组合';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.belong_org_pct_comnt is '归属机构占比说明';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.acvmnt_belong_emply_id is '业绩归属员工编号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.acvmnt_belong_hq_emply_id is '业绩归属总行员工编号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.pay_amt is '缴款金额(元)';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.tran_acct_id is '交易账户编号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.ghb_open_bank_no is '本方开户行行号';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.fee_calc_rule_cd is '费用计算规则代码';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.remark is '备注';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ncds_issue_rest_tot.etl_timestamp is 'ETL处理时间戳';
