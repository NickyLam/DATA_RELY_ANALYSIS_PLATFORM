/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cds_pd_lmt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cds_pd_lmt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cds_pd_lmt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_pd_lmt_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,pd_cd varchar2(30) -- 期次编号
    ,curr_cd varchar2(30) -- 币种代码
    ,priv_flg varchar2(10) -- 对私标志
    ,issue_year varchar2(60) -- 发行年度
    ,tran_dt date -- 交易日期
    ,ocup_lmt number(30,2) -- 占用额度
    ,tot_amt number(30,2) -- 总额度
    ,asigned_lmt number(30,2) -- 已分配额度
    ,upper_lmt_type_cd varchar2(60) -- 上级额度类型代码
    ,surp_lmt number(30,2) -- 剩余额度
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
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
grant select on ${iml_schema}.agt_cds_pd_lmt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_cds_pd_lmt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_cds_pd_lmt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cds_pd_lmt_info_h is '大额存单期次额度信息历史';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.pd_cd is '期次编号';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.priv_flg is '对私标志';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.issue_year is '发行年度';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.ocup_lmt is '占用额度';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.tot_amt is '总额度';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.asigned_lmt is '已分配额度';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.upper_lmt_type_cd is '上级额度类型代码';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.surp_lmt is '剩余额度';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cds_pd_lmt_info_h.etl_timestamp is 'ETL处理时间戳';
