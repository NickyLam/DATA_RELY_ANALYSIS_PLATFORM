/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_inv_port_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_inv_port_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_inv_port_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_inv_port_acct(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,subor_inv_port_id varchar2(60) -- 从属投资组合编号
    ,dept_id varchar2(60) -- 部门编号
    ,haver_id varchar2(60) -- 拥有者编号
    ,haver_cd varchar2(250) -- 拥有者代码
    ,haver_name varchar2(750) -- 拥有者名称
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(150) -- 投组名称
    ,deflt_acct_id varchar2(90) -- 默认账户ID
    ,deflt_asset_type_id varchar2(90) -- 默认资产类型ID
    ,final_modif_tm timestamp -- 最后修改时间
    ,data_src_app_set_id varchar2(90) -- 数据源应用设置ID
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,status_cd varchar2(10) -- 状态代码
    ,non_st_at_cate_cd varchar2(10) -- 非标资产类别代码
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
grant select on ${iml_schema}.agt_inv_port_acct to ${icl_schema};
grant select on ${iml_schema}.agt_inv_port_acct to ${idl_schema};
grant select on ${iml_schema}.agt_inv_port_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_inv_port_acct is '投资组合账户';
comment on column ${iml_schema}.agt_inv_port_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_inv_port_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_inv_port_acct.subor_inv_port_id is '从属投资组合编号';
comment on column ${iml_schema}.agt_inv_port_acct.dept_id is '部门编号';
comment on column ${iml_schema}.agt_inv_port_acct.haver_id is '拥有者编号';
comment on column ${iml_schema}.agt_inv_port_acct.haver_cd is '拥有者代码';
comment on column ${iml_schema}.agt_inv_port_acct.haver_name is '拥有者名称';
comment on column ${iml_schema}.agt_inv_port_acct.portf_id is '投组编号';
comment on column ${iml_schema}.agt_inv_port_acct.portf_name is '投组名称';
comment on column ${iml_schema}.agt_inv_port_acct.deflt_acct_id is '默认账户ID';
comment on column ${iml_schema}.agt_inv_port_acct.deflt_asset_type_id is '默认资产类型ID';
comment on column ${iml_schema}.agt_inv_port_acct.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.agt_inv_port_acct.data_src_app_set_id is '数据源应用设置ID';
comment on column ${iml_schema}.agt_inv_port_acct.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_inv_port_acct.status_cd is '状态代码';
comment on column ${iml_schema}.agt_inv_port_acct.non_st_at_cate_cd is '非标资产类别代码';
comment on column ${iml_schema}.agt_inv_port_acct.create_dt is '创建日期';
comment on column ${iml_schema}.agt_inv_port_acct.update_dt is '更新日期';
comment on column ${iml_schema}.agt_inv_port_acct.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_inv_port_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_inv_port_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_inv_port_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_inv_port_acct.etl_timestamp is 'ETL处理时间戳';
