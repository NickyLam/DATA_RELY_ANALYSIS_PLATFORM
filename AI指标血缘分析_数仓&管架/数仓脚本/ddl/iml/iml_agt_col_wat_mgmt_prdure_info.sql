/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_col_wat_mgmt_prdure_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_col_wat_mgmt_prdure_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_col_wat_mgmt_prdure_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_wat_mgmt_prdure_info(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,wat_temp_borwer_name varchar2(150) -- 权证临时借用人名称
    ,wat_temp_ex_renew_rs_cd varchar2(10) -- 权证临时出库续期原因代码
    ,wat_temp_ex_renew_spec_rs varchar2(750) -- 权证临时出库续期具体原因
    ,wat_expect_rtn_dt date -- 权证预计归还日期
    ,operr_id varchar2(60) -- 经办人编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,oper_dt date -- 经办日期
    ,wat_info_happ_chg_flg varchar2(10) -- 权证信息是否发生变化标志
    ,wat_info_chg_situ_cd varchar2(10) -- 权证信息变化情况代码
    ,wat_info_chg_situ_descb varchar2(750) -- 权证信息变化情况描述
    ,new_right_vouch_id varchar2(200) -- 新权利凭证编号
    ,wat_nomal_ex_rs_cd varchar2(30) -- 权证正常出库原因代码
    ,wat_nomal_ex_spec_rs varchar2(750) -- 权证正常出库具体原因
    ,remark varchar2(4000) -- 备注
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_col_wat_mgmt_prdure_info to ${icl_schema};
grant select on ${iml_schema}.agt_col_wat_mgmt_prdure_info to ${idl_schema};
grant select on ${iml_schema}.agt_col_wat_mgmt_prdure_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_col_wat_mgmt_prdure_info is '押品权证管理过程信息';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.bus_id is '业务编号';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_temp_borwer_name is '权证临时借用人名称';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_temp_ex_renew_rs_cd is '权证临时出库续期原因代码';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_temp_ex_renew_spec_rs is '权证临时出库续期具体原因';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_expect_rtn_dt is '权证预计归还日期';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.operr_id is '经办人编号';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_info_happ_chg_flg is '权证信息是否发生变化标志';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_info_chg_situ_cd is '权证信息变化情况代码';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_info_chg_situ_descb is '权证信息变化情况描述';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.new_right_vouch_id is '新权利凭证编号';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_nomal_ex_rs_cd is '权证正常出库原因代码';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.wat_nomal_ex_spec_rs is '权证正常出库具体原因';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.remark is '备注';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_col_wat_mgmt_prdure_info.etl_timestamp is 'ETL处理时间戳';
