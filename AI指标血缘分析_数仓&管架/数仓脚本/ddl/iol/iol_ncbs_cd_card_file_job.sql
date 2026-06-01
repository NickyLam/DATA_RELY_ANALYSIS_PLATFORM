/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_card_file_job
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_card_file_job
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_card_file_job purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_file_job(
    file_name varchar2(200) -- 文件名称
    ,file_path varchar2(200) -- 文件路径
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,apply_no varchar2(50) -- 申请编号
    ,batch_job_no varchar2(50) -- 制卡文件批次号
    ,card_num number(6) -- 制卡数量
    ,company varchar2(20) -- 法人
    ,file_status varchar2(1) -- 文件状态
    ,file_type varchar2(50) -- 文件类型
    ,make_card_type varchar2(1) -- 制卡类型
    ,same_card_flag varchar2(1) -- 是否同号换卡
    ,source_type varchar2(6) -- 渠道编号
    ,apply_date date -- 申请日期
    ,expire_date date -- 失效日期
    ,start_time varchar2(26) -- 起始时间
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,card_no_from varchar2(50) -- 起始卡号
    ,card_no_thru varchar2(50) -- 截止卡号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cd_card_file_job to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_card_file_job to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_card_file_job to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_card_file_job to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_card_file_job is '制卡文件与清单信息表';
comment on column ${iol_schema}.ncbs_cd_card_file_job.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_cd_card_file_job.file_path is '文件路径';
comment on column ${iol_schema}.ncbs_cd_card_file_job.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.remark is '备注';
comment on column ${iol_schema}.ncbs_cd_card_file_job.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.apply_no is '申请编号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.batch_job_no is '制卡文件批次号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.card_num is '制卡数量';
comment on column ${iol_schema}.ncbs_cd_card_file_job.company is '法人';
comment on column ${iol_schema}.ncbs_cd_card_file_job.file_status is '文件状态';
comment on column ${iol_schema}.ncbs_cd_card_file_job.file_type is '文件类型';
comment on column ${iol_schema}.ncbs_cd_card_file_job.make_card_type is '制卡类型';
comment on column ${iol_schema}.ncbs_cd_card_file_job.same_card_flag is '是否同号换卡';
comment on column ${iol_schema}.ncbs_cd_card_file_job.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.apply_date is '申请日期';
comment on column ${iol_schema}.ncbs_cd_card_file_job.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_cd_card_file_job.start_time is '起始时间';
comment on column ${iol_schema}.ncbs_cd_card_file_job.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cd_card_file_job.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_card_file_job.card_no_from is '起始卡号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.card_no_thru is '截止卡号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cd_card_file_job.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cd_card_file_job.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cd_card_file_job.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cd_card_file_job.etl_timestamp is 'ETL处理时间戳';
