/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_pass_bus_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_pass_bus_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_pass_bus_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pass_bus_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,pass_bus_id varchar2(100) -- 通道业务编号
    ,passer_id varchar2(100) -- 通道方编号
    ,passer_name varchar2(375) -- 通道方名称
    ,mger_id varchar2(100) -- 管理人编号
    ,trustee_id varchar2(100) -- 托管人编号
    ,layered_stru_flg varchar2(10) -- 分层结构标志
    ,mgmt_form_cd varchar2(30) -- 管理形式代码
    ,espec_aim_vector_type_cd varchar2(30) -- 特殊目的载体类型代码
    ,coll_tot_amt number(30,6) -- 募集总金额
    ,nv_item_flg varchar2(10) -- 净值项标志
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,espec_aim_vector_recd_num varchar2(60) -- 特殊目的载体备案号
    ,prod_name varchar2(500) -- 产品名称
    ,pass_fee_rat number(30,6) -- 通道费率
    ,have_ext_rating_flg varchar2(10) -- 有外部评级标志
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_pass_bus_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_pass_bus_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_pass_bus_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_pass_bus_info_h is '通道业务信息历史';
comment on column ${iml_schema}.agt_pass_bus_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.pass_bus_id is '通道业务编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.passer_id is '通道方编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.passer_name is '通道方名称';
comment on column ${iml_schema}.agt_pass_bus_info_h.mger_id is '管理人编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.trustee_id is '托管人编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.layered_stru_flg is '分层结构标志';
comment on column ${iml_schema}.agt_pass_bus_info_h.mgmt_form_cd is '管理形式代码';
comment on column ${iml_schema}.agt_pass_bus_info_h.espec_aim_vector_type_cd is '特殊目的载体类型代码';
comment on column ${iml_schema}.agt_pass_bus_info_h.coll_tot_amt is '募集总金额';
comment on column ${iml_schema}.agt_pass_bus_info_h.nv_item_flg is '净值项标志';
comment on column ${iml_schema}.agt_pass_bus_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_pass_bus_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_pass_bus_info_h.espec_aim_vector_recd_num is '特殊目的载体备案号';
comment on column ${iml_schema}.agt_pass_bus_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.agt_pass_bus_info_h.pass_fee_rat is '通道费率';
comment on column ${iml_schema}.agt_pass_bus_info_h.have_ext_rating_flg is '有外部评级标志';
comment on column ${iml_schema}.agt_pass_bus_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_pass_bus_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_pass_bus_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_pass_bus_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_pass_bus_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_pass_bus_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_pass_bus_info_h.etl_timestamp is 'ETL处理时间戳';
