/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml chn_dir_termn_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.chn_dir_termn_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.chn_dir_termn_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_dir_termn_info_h(
    chn_id varchar2(100) -- 直联终端编号
    ,seq_num varchar2(60) -- 序号
    ,lp_id varchar2(60) -- 法人编号
    ,termn_id varchar2(60) -- 终端编号
    ,termnl_id varchar2(60) -- 终端机身编号
    ,mercht_id varchar2(60) -- 商户编号
    ,mercht_seq_num varchar2(60) -- 商户序号
    ,termn_type_cd varchar2(30) -- 终端类型代码
    ,termn_usage_cd varchar2(30) -- 终端用途代码
    ,remark varchar2(375) -- 备注
    ,iss_dt date -- 出单日期
    ,install_dt date -- 安装日期
    ,oper_type_cd varchar2(30) -- 操作类型代码
    ,termn_install_addr varchar2(750) -- 终端安装地址
    ,termn_name varchar2(750) -- 终端名称
    ,inst_tel varchar2(90) -- 装机电话
    ,termn_status_cd varchar2(60) -- 终端状态代码
    ,status_cd varchar2(30) -- 状态代码
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
grant select on ${iml_schema}.chn_dir_termn_info_h to ${icl_schema};
grant select on ${iml_schema}.chn_dir_termn_info_h to ${idl_schema};
grant select on ${iml_schema}.chn_dir_termn_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.chn_dir_termn_info_h is '直联终端信息历史';
comment on column ${iml_schema}.chn_dir_termn_info_h.chn_id is '直联终端编号';
comment on column ${iml_schema}.chn_dir_termn_info_h.seq_num is '序号';
comment on column ${iml_schema}.chn_dir_termn_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.chn_dir_termn_info_h.termn_id is '终端编号';
comment on column ${iml_schema}.chn_dir_termn_info_h.termnl_id is '终端机身编号';
comment on column ${iml_schema}.chn_dir_termn_info_h.mercht_id is '商户编号';
comment on column ${iml_schema}.chn_dir_termn_info_h.mercht_seq_num is '商户序号';
comment on column ${iml_schema}.chn_dir_termn_info_h.termn_type_cd is '终端类型代码';
comment on column ${iml_schema}.chn_dir_termn_info_h.termn_usage_cd is '终端用途代码';
comment on column ${iml_schema}.chn_dir_termn_info_h.remark is '备注';
comment on column ${iml_schema}.chn_dir_termn_info_h.iss_dt is '出单日期';
comment on column ${iml_schema}.chn_dir_termn_info_h.install_dt is '安装日期';
comment on column ${iml_schema}.chn_dir_termn_info_h.oper_type_cd is '操作类型代码';
comment on column ${iml_schema}.chn_dir_termn_info_h.termn_install_addr is '终端安装地址';
comment on column ${iml_schema}.chn_dir_termn_info_h.termn_name is '终端名称';
comment on column ${iml_schema}.chn_dir_termn_info_h.inst_tel is '装机电话';
comment on column ${iml_schema}.chn_dir_termn_info_h.termn_status_cd is '终端状态代码';
comment on column ${iml_schema}.chn_dir_termn_info_h.status_cd is '状态代码';
comment on column ${iml_schema}.chn_dir_termn_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.chn_dir_termn_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.chn_dir_termn_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.chn_dir_termn_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.chn_dir_termn_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.chn_dir_termn_info_h.etl_timestamp is 'ETL处理时间戳';
