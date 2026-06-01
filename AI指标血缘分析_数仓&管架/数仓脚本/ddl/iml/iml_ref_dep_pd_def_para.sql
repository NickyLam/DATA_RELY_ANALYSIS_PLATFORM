/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_dep_pd_def_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_dep_pd_def_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_dep_pd_def_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dep_pd_def_para(
    pd_cd varchar2(30) -- 期次编号
    ,lp_id varchar2(100) -- 法人编号
    ,pd_descb varchar2(500) -- 期次描述
    ,cds_issue_year varchar2(60) -- 大额存单发行年度
    ,cds_issue_begin_dt date -- 大额存单发行起始日期
    ,issue_termnt_dt date -- 发行终止日期
    ,precon_start_tm timestamp -- 预约开始时间
    ,precon_end_tm timestamp -- 预约结束时间
    ,start_sell_tm timestamp -- 开起销售时间
    ,end_sell_tm timestamp -- 停止销售时间
    ,pd_prod_cate_cd varchar2(30) -- 期次产品类别代码
    ,lmt_deduct_type_cd varchar2(30) -- 额度扣减类型代码
    ,pd_dtl_remark varchar2(500) -- 期次详细备注
    ,pd_status_cd varchar2(30) -- 期次状态代码
    ,sell_way_cd varchar2(30) -- 销售方式代码
    ,assign_lmt_type_cd varchar2(30) -- 配额类型代码
    ,tot_lmt_lmt number(30,2) -- 总限制额度
    ,cds_surp_lmt number(30,2) -- 大额存单剩余额度
    ,asigned_lmt number(30,2) -- 已分配额度
    ,cds_occu_lmt number(30,2) -- 大额存单已占用额度
    ,lmt_callbk_status_cd varchar2(30) -- 额度回收状态代码
    ,ration_way_cd varchar2(30) -- 配售方式代码
    ,tran_acct_flg varchar2(10) -- 转账标志
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,dep_tenor number(10) -- 存款期限
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,int_rat_reset_freq_cd varchar2(30) -- 利率重置频率代码
    ,max_buy_amt number(30,2) -- 最大购买金额
    ,init_amt number(30,2) -- 起存金额
    ,get_int_freq_cd varchar2(30) -- 取息频率代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,cds_pay_int_way varchar2(30) -- 大额存单付息方式代码
    ,allow_unexp_draw_flg varchar2(10) -- 允许提前支取标志
    ,pa_ext_cnt number(10) -- 部提次数
    ,redembl_flg varchar2(10) -- 可赎回标志
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(500) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auto_payoff_flg varchar2(10) -- 自动结清标志
    ,white_list_sale_flg varchar2(10) -- 白名单发售标志
    ,supt_buy_way_cd varchar2(30) -- 支持购买方式代码
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
grant select on ${iml_schema}.ref_dep_pd_def_para to ${icl_schema};
grant select on ${iml_schema}.ref_dep_pd_def_para to ${idl_schema};
grant select on ${iml_schema}.ref_dep_pd_def_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_dep_pd_def_para is '存款期次定义参数表';
comment on column ${iml_schema}.ref_dep_pd_def_para.pd_cd is '期次编号';
comment on column ${iml_schema}.ref_dep_pd_def_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_dep_pd_def_para.pd_descb is '期次描述';
comment on column ${iml_schema}.ref_dep_pd_def_para.cds_issue_year is '大额存单发行年度';
comment on column ${iml_schema}.ref_dep_pd_def_para.cds_issue_begin_dt is '大额存单发行起始日期';
comment on column ${iml_schema}.ref_dep_pd_def_para.issue_termnt_dt is '发行终止日期';
comment on column ${iml_schema}.ref_dep_pd_def_para.precon_start_tm is '预约开始时间';
comment on column ${iml_schema}.ref_dep_pd_def_para.precon_end_tm is '预约结束时间';
comment on column ${iml_schema}.ref_dep_pd_def_para.start_sell_tm is '开起销售时间';
comment on column ${iml_schema}.ref_dep_pd_def_para.end_sell_tm is '停止销售时间';
comment on column ${iml_schema}.ref_dep_pd_def_para.pd_prod_cate_cd is '期次产品类别代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.lmt_deduct_type_cd is '额度扣减类型代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.pd_dtl_remark is '期次详细备注';
comment on column ${iml_schema}.ref_dep_pd_def_para.pd_status_cd is '期次状态代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.sell_way_cd is '销售方式代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.assign_lmt_type_cd is '配额类型代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.tot_lmt_lmt is '总限制额度';
comment on column ${iml_schema}.ref_dep_pd_def_para.cds_surp_lmt is '大额存单剩余额度';
comment on column ${iml_schema}.ref_dep_pd_def_para.asigned_lmt is '已分配额度';
comment on column ${iml_schema}.ref_dep_pd_def_para.cds_occu_lmt is '大额存单已占用额度';
comment on column ${iml_schema}.ref_dep_pd_def_para.lmt_callbk_status_cd is '额度回收状态代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.ration_way_cd is '配售方式代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.tran_acct_flg is '转账标志';
comment on column ${iml_schema}.ref_dep_pd_def_para.prod_id is '产品编号';
comment on column ${iml_schema}.ref_dep_pd_def_para.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.dep_tenor is '存款期限';
comment on column ${iml_schema}.ref_dep_pd_def_para.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.int_rat_reset_freq_cd is '利率重置频率代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.max_buy_amt is '最大购买金额';
comment on column ${iml_schema}.ref_dep_pd_def_para.init_amt is '起存金额';
comment on column ${iml_schema}.ref_dep_pd_def_para.get_int_freq_cd is '取息频率代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.cds_pay_int_way is '大额存单付息方式代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.allow_unexp_draw_flg is '允许提前支取标志';
comment on column ${iml_schema}.ref_dep_pd_def_para.pa_ext_cnt is '部提次数';
comment on column ${iml_schema}.ref_dep_pd_def_para.redembl_flg is '可赎回标志';
comment on column ${iml_schema}.ref_dep_pd_def_para.tran_dt is '交易日期';
comment on column ${iml_schema}.ref_dep_pd_def_para.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.ref_dep_pd_def_para.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.ref_dep_pd_def_para.auto_payoff_flg is '自动结清标志';
comment on column ${iml_schema}.ref_dep_pd_def_para.white_list_sale_flg is '白名单发售标志';
comment on column ${iml_schema}.ref_dep_pd_def_para.supt_buy_way_cd is '支持购买方式代码';
comment on column ${iml_schema}.ref_dep_pd_def_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_dep_pd_def_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_dep_pd_def_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_dep_pd_def_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_dep_pd_def_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_dep_pd_def_para.etl_timestamp is 'ETL处理时间戳';
