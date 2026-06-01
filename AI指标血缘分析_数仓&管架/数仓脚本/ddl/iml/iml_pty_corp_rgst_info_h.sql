/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_corp_rgst_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_corp_rgst_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_corp_rgst_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_rgst_info_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,found_dt date -- 成立日期
    ,rgst_cd varchar2(100) -- 登记注册代码
    ,oper_field_prop_cd varchar2(10) -- 经营场地所有权代码
    ,oper_range varchar2(4000) -- 经营范围
    ,corp_rgst_type_cd varchar2(10) -- 企业登记注册类型代码
    ,paid_in_capital number(30,2) -- 实收资本
    ,paid_in_capital_curr_cd varchar2(30) -- 实收资本币种代码
    ,invtor_cty_cd varchar2(10) -- 投资方国家代码
    ,rgst_cap number(30,2) -- 注册资本
    ,rgst_cap_curr_cd varchar2(30) -- 注册资本币种代码
    ,asset_tot number(30,2) -- 集团资产总额
    ,leg_oper_situ varchar2(1000) -- 合法经营情况
    ,oper_field_area number(38,2) -- 经营场地面积
    ,major_prod_serv_situ varchar2(250) -- 主要产品和服务情况
    ,work_rg_dist_cd varchar2(30) -- 办公地区行政区划代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_corp_rgst_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_corp_rgst_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_corp_rgst_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_corp_rgst_info_h is '公司登记注册信息历史';
comment on column ${iml_schema}.pty_corp_rgst_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_corp_rgst_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_corp_rgst_info_h.found_dt is '成立日期';
comment on column ${iml_schema}.pty_corp_rgst_info_h.rgst_cd is '登记注册代码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.oper_field_prop_cd is '经营场地所有权代码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.oper_range is '经营范围';
comment on column ${iml_schema}.pty_corp_rgst_info_h.corp_rgst_type_cd is '企业登记注册类型代码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.paid_in_capital is '实收资本';
comment on column ${iml_schema}.pty_corp_rgst_info_h.paid_in_capital_curr_cd is '实收资本币种代码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.invtor_cty_cd is '投资方国家代码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.rgst_cap is '注册资本';
comment on column ${iml_schema}.pty_corp_rgst_info_h.rgst_cap_curr_cd is '注册资本币种代码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.asset_tot is '集团资产总额';
comment on column ${iml_schema}.pty_corp_rgst_info_h.leg_oper_situ is '合法经营情况';
comment on column ${iml_schema}.pty_corp_rgst_info_h.oper_field_area is '经营场地面积';
comment on column ${iml_schema}.pty_corp_rgst_info_h.major_prod_serv_situ is '主要产品和服务情况';
comment on column ${iml_schema}.pty_corp_rgst_info_h.work_rg_dist_cd is '办公地区行政区划代码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_corp_rgst_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_corp_rgst_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_corp_rgst_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_corp_rgst_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_corp_rgst_info_h.etl_timestamp is 'ETL处理时间戳';
