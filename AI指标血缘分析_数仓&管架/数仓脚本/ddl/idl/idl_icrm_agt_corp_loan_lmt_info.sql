/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_agt_corp_loan_lmt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_agt_corp_loan_lmt_info
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_agt_corp_loan_lmt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_agt_corp_loan_lmt_info(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,up_level_lmt_flow_num varchar2(60) -- 上层额度流水号
    ,lmt_bus_breed_id varchar2(60) -- 额度业务品种编号
    ,rela_obj_type_cd varchar2(30) -- 关联对象类型代码
    ,rela_obj_id varchar2(60) -- 关联对象编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(100) -- 客户名称
    ,curr_cd varchar2(10) -- 币种代码
    ,lmt_amt number(30,2) -- 额度金额
    ,lmt_open number(30,2) -- 额度敞口
    ,exlus_flg varchar2(10) -- 专属标志
    ,circl_flg varchar2(10) -- 循环标志
    ,margin_ratio number(18,6) -- 保证金比率
    ,perds number(10) -- 期数
    ,tenor_val number(18,6) -- 期限值
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,lmt_update_dt date -- 额度更新日期
    ,invest_way_cd varchar2(10) -- 投资方式代码
    ,onl_lmt number(30,2) -- 线上额度
    ,ts_appl_amt number(30,2) -- 暂存申请金额
    ,ts_open_amt number(30,2) -- 暂存敞口金额
    ,ts_onl_amt number(30,2) -- 暂存线上金额
    ,group_corp_cust_crdt_lmt number(30,2) -- 集团公司客户授信额度
    ,group_corp_cust_crdt_open number(30,2) -- 集团公司客户授信敞口
    ,group_ibank_cust_crdt_lmt number(30,2) -- 集团同业客户授信额度
    ,group_ibank_cust_crdt_open number(30,2) -- 集团同业客户授信敞口
    ,ts_group_corp_cust_crdt_lmt number(30,2) -- 暂存集团公司客户授信额度
    ,ts_group_corp_cust_crdt_open number(30,2) -- 暂存集团公司客户授信敞口
    ,ts_group_ibank_cust_crdt_lmt number(30,2) -- 暂存集团同业客户授信额度
    ,ts_group_ibank_cust_crdt_open number(30,2) -- 暂存集团同业客户授信敞口
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
grant select on ${idl_schema}.icrm_agt_corp_loan_lmt_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_agt_corp_loan_lmt_info is '公司贷款额度信息表';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.agt_id is '协议编号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.up_level_lmt_flow_num is '上层额度流水号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.lmt_bus_breed_id is '额度业务品种编号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.rela_obj_type_cd is '关联对象类型代码';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.rela_obj_id is '关联对象编号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.cust_id is '客户编号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.cust_name is '客户名称';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.lmt_amt is '额度金额';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.lmt_open is '额度敞口';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.exlus_flg is '专属标志';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.circl_flg is '循环标志';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.margin_ratio is '保证金比率';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.perds is '期数';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.tenor_val is '期限值';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.begin_dt is '起始日期';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.rgst_dt is '登记日期';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.lmt_update_dt is '额度更新日期';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.invest_way_cd is '投资方式代码';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.onl_lmt is '线上额度';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.ts_appl_amt is '暂存申请金额';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.ts_open_amt is '暂存敞口金额';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.ts_onl_amt is '暂存线上金额';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.group_corp_cust_crdt_lmt is '集团公司客户授信额度';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.group_corp_cust_crdt_open is '集团公司客户授信敞口';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.group_ibank_cust_crdt_lmt is '集团同业客户授信额度';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.group_ibank_cust_crdt_open is '集团同业客户授信敞口';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.ts_group_corp_cust_crdt_lmt is '暂存集团公司客户授信额度';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.ts_group_corp_cust_crdt_open is '暂存集团公司客户授信敞口';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.ts_group_ibank_cust_crdt_lmt is '暂存集团同业客户授信额度';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.ts_group_ibank_cust_crdt_open is '暂存集团同业客户授信敞口';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_agt_corp_loan_lmt_info.etl_timestamp is '数据处理时间';
