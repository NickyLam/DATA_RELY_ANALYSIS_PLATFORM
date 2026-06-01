/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ym_fund_nv_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ym_fund_nv_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ym_fund_nv_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ym_fund_nv_info(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,nv_dt date -- 净值日期
    ,fund_cd varchar2(60) -- 基金代码
    ,serv_plat_abbr varchar2(90) -- 服务平台简称
    ,mercht_id varchar2(100) -- 商户编号
    ,corp_nv number(18,6) -- 单位净值
    ,acm_nv number(18,6) -- 累计净值
    ,daily_incr number(18,8) -- 每日涨幅
    ,ten_thous_prft number(18,8) -- 万份收益
    ,sevn_aual_yld number(18,8) -- 七日年化收益率
    ,status_dt date -- 状态日期
    ,fund_status_cd varchar2(30) -- 基金状态代码
    ,fund_tran_status_cd varchar2(30) -- 基金转换状态代码
    ,aip_status_cd varchar2(30) -- 定投状态代码
    ,update_tm timestamp -- 更新时间
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
grant select on ${iml_schema}.prd_ym_fund_nv_info to ${icl_schema};
grant select on ${iml_schema}.prd_ym_fund_nv_info to ${idl_schema};
grant select on ${iml_schema}.prd_ym_fund_nv_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ym_fund_nv_info is '盈米基金净值信息';
comment on column ${iml_schema}.prd_ym_fund_nv_info.prod_id is '产品编号';
comment on column ${iml_schema}.prd_ym_fund_nv_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ym_fund_nv_info.nv_dt is '净值日期';
comment on column ${iml_schema}.prd_ym_fund_nv_info.fund_cd is '基金代码';
comment on column ${iml_schema}.prd_ym_fund_nv_info.serv_plat_abbr is '服务平台简称';
comment on column ${iml_schema}.prd_ym_fund_nv_info.mercht_id is '商户编号';
comment on column ${iml_schema}.prd_ym_fund_nv_info.corp_nv is '单位净值';
comment on column ${iml_schema}.prd_ym_fund_nv_info.acm_nv is '累计净值';
comment on column ${iml_schema}.prd_ym_fund_nv_info.daily_incr is '每日涨幅';
comment on column ${iml_schema}.prd_ym_fund_nv_info.ten_thous_prft is '万份收益';
comment on column ${iml_schema}.prd_ym_fund_nv_info.sevn_aual_yld is '七日年化收益率';
comment on column ${iml_schema}.prd_ym_fund_nv_info.status_dt is '状态日期';
comment on column ${iml_schema}.prd_ym_fund_nv_info.fund_status_cd is '基金状态代码';
comment on column ${iml_schema}.prd_ym_fund_nv_info.fund_tran_status_cd is '基金转换状态代码';
comment on column ${iml_schema}.prd_ym_fund_nv_info.aip_status_cd is '定投状态代码';
comment on column ${iml_schema}.prd_ym_fund_nv_info.update_tm is '更新时间';
comment on column ${iml_schema}.prd_ym_fund_nv_info.create_dt is '创建日期';
comment on column ${iml_schema}.prd_ym_fund_nv_info.update_dt is '更新日期';
comment on column ${iml_schema}.prd_ym_fund_nv_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_ym_fund_nv_info.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ym_fund_nv_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ym_fund_nv_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ym_fund_nv_info.etl_timestamp is 'ETL处理时间戳';
