/*
Purpose:    整合模型层-公共代码历史表，切片存储公共代码历史数据
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_pub_cd_his
CreateDate: 20221023
FileType:   DDL
Logs:
    曹永茂 20221023 新建表本
*/

prompt creating table ${iml_schema}.ref_pub_cd_his
whenever sqlerror continue none;
drop table ${iml_schema}.ref_pub_cd_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_pub_cd_his(
    cd_id varchar2(60) -- 代码编号
    ,cd_tab_en_name varchar2(60) -- 代码表英文名称
    ,cd_tab_cn_descb varchar2(250) -- 代码表中文描述
    ,cd_val varchar2(30) -- 代码值
    ,cd_descb varchar2(1000) -- 代码描述
	  ,parent_cd varchar2(30) --父级代码
    ,valid_flg varchar2(10) --有效标志
    ,invalid_dt date --失效日期
    ,data_std_flg varchar2(10) -- 数据标准标志
    ,quote_data_std varchar2(10) -- 引用数据标准
    ,remark varchar2(100) -- 备注
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;
-- grant
grant select on ${iml_schema}.ref_pub_cd_his to ${icl_schema};
grant select on ${iml_schema}.ref_pub_cd_his to ${idl_schema};
grant select on ${iml_schema}.ref_pub_cd_his to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_pub_cd_his is '公共代码历史表';
comment on column ${iml_schema}.ref_pub_cd_his.cd_id is '代码编号';
comment on column ${iml_schema}.ref_pub_cd_his.cd_tab_en_name is '代码表英文名称';
comment on column ${iml_schema}.ref_pub_cd_his.cd_tab_cn_descb is '代码表中文描述';
comment on column ${iml_schema}.ref_pub_cd_his.cd_val is '代码值';
comment on column ${iml_schema}.ref_pub_cd_his.cd_descb is '代码描述';
comment on column ${iml_schema}.ref_pub_cd_his.parent_cd is '父级代码';
comment on column ${iml_schema}.ref_pub_cd_his.valid_flg is '有效标志';
comment on column ${iml_schema}.ref_pub_cd_his.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_pub_cd_his.data_std_flg is '数据标准标志';
comment on column ${iml_schema}.ref_pub_cd_his.quote_data_std is '引用数据标准';
comment on column ${iml_schema}.ref_pub_cd_his.remark is '备注';
comment on column ${iml_schema}.ref_pub_cd_his.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_pub_cd_his.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_pub_cd_his.job_cd is '任务编码';
comment on column ${iml_schema}.ref_pub_cd_his.etl_timestamp is 'ETL处理时间戳';
