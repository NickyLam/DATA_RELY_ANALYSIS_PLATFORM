/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_trust_day_sell_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_trust_day_sell_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_trust_day_sell_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_trust_day_sell_h(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(30) -- TA代码
    ,issue_dt date -- 发布日期
    ,prod_size number(30,2) -- 产品规模
    ,lot number(30,2) -- 份额
    ,td_add_lot number(30,2) -- 当日增加份额
    ,td_decrs_lot number(30,2) -- 当日减少份额
    ,prod_nv number(30,8) -- 产品净值
    ,prod_fac_val number(30,8) -- 产品面值
    ,aual_yld number(18,8) -- 年化收益率
    ,prod_prft number(30,8) -- 产品收益
    ,ten_thous_corp_prft number(30,8) -- 万份单位收益
    ,prft_assign_flg varchar2(10) -- 收益分配标志
    ,tran_flg varchar2(10) -- 转换标志
    ,status_cd varchar2(30) -- 状态代码
    ,ld_prod_status_cd varchar2(30) -- 上日产品状态代码
    ,prod_acm_nv number(38,8) -- 产品累计净值
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_trust_day_sell_h to ${icl_schema};
grant select on ${iml_schema}.prd_trust_day_sell_h to ${idl_schema};
grant select on ${iml_schema}.prd_trust_day_sell_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_trust_day_sell_h is '信托产品日销售信息历史';
comment on column ${iml_schema}.prd_trust_day_sell_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_trust_day_sell_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_trust_day_sell_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_trust_day_sell_h.issue_dt is '发布日期';
comment on column ${iml_schema}.prd_trust_day_sell_h.prod_size is '产品规模';
comment on column ${iml_schema}.prd_trust_day_sell_h.lot is '份额';
comment on column ${iml_schema}.prd_trust_day_sell_h.td_add_lot is '当日增加份额';
comment on column ${iml_schema}.prd_trust_day_sell_h.td_decrs_lot is '当日减少份额';
comment on column ${iml_schema}.prd_trust_day_sell_h.prod_nv is '产品净值';
comment on column ${iml_schema}.prd_trust_day_sell_h.prod_fac_val is '产品面值';
comment on column ${iml_schema}.prd_trust_day_sell_h.aual_yld is '年化收益率';
comment on column ${iml_schema}.prd_trust_day_sell_h.prod_prft is '产品收益';
comment on column ${iml_schema}.prd_trust_day_sell_h.ten_thous_corp_prft is '万份单位收益';
comment on column ${iml_schema}.prd_trust_day_sell_h.prft_assign_flg is '收益分配标志';
comment on column ${iml_schema}.prd_trust_day_sell_h.tran_flg is '转换标志';
comment on column ${iml_schema}.prd_trust_day_sell_h.status_cd is '状态代码';
comment on column ${iml_schema}.prd_trust_day_sell_h.ld_prod_status_cd is '上日产品状态代码';
comment on column ${iml_schema}.prd_trust_day_sell_h.prod_acm_nv is '产品累计净值';
comment on column ${iml_schema}.prd_trust_day_sell_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_trust_day_sell_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_trust_day_sell_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_trust_day_sell_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_trust_day_sell_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_trust_day_sell_h.etl_timestamp is 'ETL处理时间戳';
