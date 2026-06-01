/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_family_situ_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_family_situ_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_family_situ_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_family_situ_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,loc_resd_years number(10) -- 本地居住年限
    ,local_estate_flg varchar2(10) -- 当地房产标志
    ,local_soci_secu_flg varchar2(10) -- 当地社保标志
    ,house_val_cd varchar2(30) -- 房屋价值
    ,prov_pulation_type_cd varchar2(10) -- 供养人口
    ,rpr_char_cd varchar2(100) -- 户籍性质代码
    ,resdnt_status_cd varchar2(10) -- 居住状况代码
    ,child_number_cd varchar2(10) -- 子女人数
    ,free_car_situ_cd varchar2(10) -- 自由汽车状况代码
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
grant select on ${iml_schema}.pty_party_family_situ_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_family_situ_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_family_situ_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_family_situ_h is '当事人家庭状况历史';
comment on column ${iml_schema}.pty_party_family_situ_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_family_situ_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_family_situ_h.loc_resd_years is '本地居住年限';
comment on column ${iml_schema}.pty_party_family_situ_h.local_estate_flg is '当地房产标志';
comment on column ${iml_schema}.pty_party_family_situ_h.local_soci_secu_flg is '当地社保标志';
comment on column ${iml_schema}.pty_party_family_situ_h.house_val_cd is '房屋价值';
comment on column ${iml_schema}.pty_party_family_situ_h.prov_pulation_type_cd is '供养人口';
comment on column ${iml_schema}.pty_party_family_situ_h.rpr_char_cd is '户籍性质代码';
comment on column ${iml_schema}.pty_party_family_situ_h.resdnt_status_cd is '居住状况代码';
comment on column ${iml_schema}.pty_party_family_situ_h.child_number_cd is '子女人数';
comment on column ${iml_schema}.pty_party_family_situ_h.free_car_situ_cd is '自由汽车状况代码';
comment on column ${iml_schema}.pty_party_family_situ_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_family_situ_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_family_situ_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_family_situ_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_family_situ_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_family_situ_h.etl_timestamp is 'ETL处理时间戳';
