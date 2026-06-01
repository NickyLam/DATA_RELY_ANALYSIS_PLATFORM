/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_insure_fee_rat_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_insure_fee_rat_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_insure_fee_rat_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_insure_fee_rat_info_h(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,corp_cd varchar2(30) -- 公司代码
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,org_id varchar2(100) -- 机构编号
    ,insure_mode_pay_cd varchar2(30) -- 保险支付方式代码
    ,pay_year_term varchar2(45) -- 缴费年期
    ,fee_mode_cd varchar2(30) -- 费用模式代码
    ,calc_para number(30,6) -- 计算参数
    ,up_lolmi_ctrl_flg varchar2(10) -- 上下限控制标志
    ,sig_max_amt number(30,6) -- 单笔最大金额
    ,sig_min_amt number(30,6) -- 单笔最小金额
    ,iss_fee number(30,6) -- 出单费
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,guar_term_type_cd varchar2(30) -- 保障年期类型代码
    ,guar_year_term varchar2(45) -- 保障年期
    ,sig_lowt_permium number(30,6) -- 单笔最低保费
    ,sig_higt_permium number(30,6) -- 单笔最高保费
    ,insure_year number(30) -- 保险年度
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_insure_fee_rat_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_insure_fee_rat_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_insure_fee_rat_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_insure_fee_rat_info_h is '保险产品费率信息历史';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.corp_cd is '公司代码';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.org_id is '机构编号';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.insure_mode_pay_cd is '保险支付方式代码';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.pay_year_term is '缴费年期';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.fee_mode_cd is '费用模式代码';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.calc_para is '计算参数';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.up_lolmi_ctrl_flg is '上下限控制标志';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.sig_max_amt is '单笔最大金额';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.sig_min_amt is '单笔最小金额';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.iss_fee is '出单费';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.guar_term_type_cd is '保障年期类型代码';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.guar_year_term is '保障年期';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.sig_lowt_permium is '单笔最低保费';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.sig_higt_permium is '单笔最高保费';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.insure_year is '保险年度';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_insure_fee_rat_info_h.etl_timestamp is 'ETL处理时间戳';
