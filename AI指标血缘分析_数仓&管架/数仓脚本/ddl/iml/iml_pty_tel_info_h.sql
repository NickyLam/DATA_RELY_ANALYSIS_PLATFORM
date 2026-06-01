/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_tel_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_tel_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_tel_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_tel_info_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_sys_cd varchar2(10) -- 源系统代码
    ,tel_type_cd varchar2(30) -- 电话类型代码
    ,seq_num varchar2(60) -- 序号
    ,tel_num varchar2(500) -- 电话号码
    ,main_tel_num_flg varchar2(200) -- 主电话号码标志
    ,dd_area_cd varchar2(60) -- 长途区号
    ,ext_num varchar2(60) -- 分机号码
    ,tel_char_cd varchar2(60) -- 电话性质代码
    ,real_name_cert_que_rest varchar2(1000) -- 实名认证查询结果
    ,latest_chn_cd varchar2(30) -- 最新渠道代码
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
grant select on ${iml_schema}.pty_tel_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_tel_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_tel_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_tel_info_h is '当事人电话信息历史';
comment on column ${iml_schema}.pty_tel_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_tel_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_tel_info_h.src_sys_cd is '源系统代码';
comment on column ${iml_schema}.pty_tel_info_h.tel_type_cd is '电话类型代码';
comment on column ${iml_schema}.pty_tel_info_h.seq_num is '序号';
comment on column ${iml_schema}.pty_tel_info_h.tel_num is '电话号码';
comment on column ${iml_schema}.pty_tel_info_h.main_tel_num_flg is '主电话号码标志';
comment on column ${iml_schema}.pty_tel_info_h.dd_area_cd is '长途区号';
comment on column ${iml_schema}.pty_tel_info_h.ext_num is '分机号码';
comment on column ${iml_schema}.pty_tel_info_h.tel_char_cd is '电话性质代码';
comment on column ${iml_schema}.pty_tel_info_h.real_name_cert_que_rest is '实名认证查询结果';
comment on column ${iml_schema}.pty_tel_info_h.latest_chn_cd is '最新渠道代码';
comment on column ${iml_schema}.pty_tel_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.pty_tel_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_tel_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_tel_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_tel_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_tel_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_tel_info_h.etl_timestamp is 'ETL处理时间戳';
