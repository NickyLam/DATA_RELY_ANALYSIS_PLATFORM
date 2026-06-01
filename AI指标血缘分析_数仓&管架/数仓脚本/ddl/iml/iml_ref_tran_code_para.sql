/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tran_code_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tran_code_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tran_code_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tran_code_para(
    tran_code varchar2(30) -- 交易码
    ,bus_cls_cd varchar2(30) -- 业务分类代码
    ,a_calc_bal_stop_pay_flg varchar2(10) -- 重新计算余额止付标志
    ,revs_tran_code varchar2(30) -- 冲正交易码
    ,tran_code_descb varchar2(500) -- 交易码描述
    ,cntpty_tran_code varchar2(30) -- 对方交易码
    ,a_calc_lmt_amt_flg varchar2(10) -- 重新计算限制金额标志
    ,revs_flg varchar2(10) -- 冲正标志
    ,chn_id varchar2(100) -- 渠道编号
    ,aval_bal_calc_type_cd varchar2(30) -- 可用余额计算类型代码
    ,multi_revs_way_flg varchar2(10) -- 多种冲正方式标志
    ,cash_tran_flg varchar2(10) -- 现金交易标志
    ,cor_tran_flg varchar2(10) -- 更正交易标志
    ,tran_cls_cd varchar2(30) -- 交易分类代码
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,lp_id varchar2(100) -- 法人编号
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
grant select on ${iml_schema}.ref_tran_code_para to ${icl_schema};
grant select on ${iml_schema}.ref_tran_code_para to ${idl_schema};
grant select on ${iml_schema}.ref_tran_code_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tran_code_para is '交易码参数表';
comment on column ${iml_schema}.ref_tran_code_para.tran_code is '交易码';
comment on column ${iml_schema}.ref_tran_code_para.bus_cls_cd is '业务分类代码';
comment on column ${iml_schema}.ref_tran_code_para.a_calc_bal_stop_pay_flg is '重新计算余额止付标志';
comment on column ${iml_schema}.ref_tran_code_para.revs_tran_code is '冲正交易码';
comment on column ${iml_schema}.ref_tran_code_para.tran_code_descb is '交易码描述';
comment on column ${iml_schema}.ref_tran_code_para.cntpty_tran_code is '对方交易码';
comment on column ${iml_schema}.ref_tran_code_para.a_calc_lmt_amt_flg is '重新计算限制金额标志';
comment on column ${iml_schema}.ref_tran_code_para.revs_flg is '冲正标志';
comment on column ${iml_schema}.ref_tran_code_para.chn_id is '渠道编号';
comment on column ${iml_schema}.ref_tran_code_para.aval_bal_calc_type_cd is '可用余额计算类型代码';
comment on column ${iml_schema}.ref_tran_code_para.multi_revs_way_flg is '多种冲正方式标志';
comment on column ${iml_schema}.ref_tran_code_para.cash_tran_flg is '现金交易标志';
comment on column ${iml_schema}.ref_tran_code_para.cor_tran_flg is '更正交易标志';
comment on column ${iml_schema}.ref_tran_code_para.tran_cls_cd is '交易分类代码';
comment on column ${iml_schema}.ref_tran_code_para.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.ref_tran_code_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_tran_code_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_tran_code_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_tran_code_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_tran_code_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tran_code_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tran_code_para.etl_timestamp is 'ETL处理时间戳';
