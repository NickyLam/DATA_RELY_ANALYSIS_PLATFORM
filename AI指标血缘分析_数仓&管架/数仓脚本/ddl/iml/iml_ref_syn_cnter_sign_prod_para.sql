/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_syn_cnter_sign_prod_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_syn_cnter_sign_prod_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_syn_cnter_sign_prod_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_syn_cnter_sign_prod_para(
    sign_agt_cd varchar2(30) -- 签约协议代码
    ,lp_id varchar2(60) -- 法人编号
    ,agt_name varchar2(750) -- 协议名称
    ,sign_way_cd varchar2(30) -- 签约方式代码
    ,realtm_sync_flg varchar2(10) -- 实时同步标志
    ,sell_obj_cd varchar2(30) -- 销售对象代码
    ,sign_obj_permit_cd varchar2(30) -- 签约对象许可代码
    ,auto_change_card_cd varchar2(30) -- 自动换卡代码
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
grant select on ${iml_schema}.ref_syn_cnter_sign_prod_para to ${icl_schema};
grant select on ${iml_schema}.ref_syn_cnter_sign_prod_para to ${idl_schema};
grant select on ${iml_schema}.ref_syn_cnter_sign_prod_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_syn_cnter_sign_prod_para is '综合柜面签约产品参数表';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.sign_agt_cd is '签约协议代码';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.agt_name is '协议名称';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.sign_way_cd is '签约方式代码';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.realtm_sync_flg is '实时同步标志';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.sell_obj_cd is '销售对象代码';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.sign_obj_permit_cd is '签约对象许可代码';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.auto_change_card_cd is '自动换卡代码';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.create_dt is '创建日期';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.update_dt is '更新日期';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_syn_cnter_sign_prod_para.etl_timestamp is 'ETL处理时间戳';
