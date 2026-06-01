/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_imp_fin_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_imp_fin_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_imp_fin_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_imp_fin_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,intnal_id varchar2(100) -- 内部编号
    ,dubil_id varchar2(100) -- 借据编号
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,base_rat number(18,8) -- 基准利率
    ,actl_int_rat number(18,8) -- 实际利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,value_dt date -- 起息日期
    ,last_int_stl_dt date -- 上一利息结算日期
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,ovdue_dt date -- 逾期日期
    ,ovdue_begin_dt date -- 逾期起始日期
    ,rela_obj_name varchar2(750) -- 关联对象名称
    ,rela_obj_id varchar2(100) -- 关联对象编号
    ,parent_bus_id varchar2(100) -- 父业务编号
    ,parent_bus_descb varchar2(750) -- 父业务描述
    ,tran_oper_dt date -- 交易经办日期
    ,tran_cmplt_dt date -- 交易完成日期
    ,tran_descb varchar2(750) -- 交易描述
    ,tran_id varchar2(100) -- 交易编号
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,fin_type_cd varchar2(30) -- 融资类型代码
    ,fin_amt_ratio number(18,6) -- 融资金额比例
    ,fin_invo_cty_rg_cd varchar2(30) -- 融资涉及国家地区代码
    ,fin_curr_cd varchar2(30) -- 融资币种代码
    ,fin_status_cd varchar2(30) -- 融资状态代码
    ,fin_days number(10) -- 融资天数
    ,fin_exp_dt date -- 融资到期日期
    ,fin_rgst_dt date -- 融资登记日期
    ,imp_fin_payfan_type_cd varchar2(30) -- 进口融资代付类型代码
    ,payfan_nomal_int_rat number(18,8) -- 代付正常利率
    ,payfan_value_dt date -- 代付起息日期
    ,bal_pay_type_cd varchar2(30) -- 收支类型代码
    ,bal_pay_amt number(30,2) -- 收支金额
    ,manuf_prd_type_cd varchar2(30) -- 制品类型代码
    ,mtg_flg varchar2(10) -- 货押标志
    ,payfan_bus_breed_cd varchar2(30) -- 代付业务品种代码
    ,expect_payfan_int number(30,3) -- 预估代付总利息
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
grant select on ${iml_schema}.agt_imp_fin_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_imp_fin_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_imp_fin_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_imp_fin_info_h is '进口融资信息历史';
comment on column ${iml_schema}.agt_imp_fin_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.intnal_id is '内部编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_imp_fin_info_h.actl_int_rat is '实际利率';
comment on column ${iml_schema}.agt_imp_fin_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_imp_fin_info_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.last_int_stl_dt is '上一利息结算日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.ovdue_flg is '逾期标志';
comment on column ${iml_schema}.agt_imp_fin_info_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_imp_fin_info_h.ovdue_dt is '逾期日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.ovdue_begin_dt is '逾期起始日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.rela_obj_name is '关联对象名称';
comment on column ${iml_schema}.agt_imp_fin_info_h.rela_obj_id is '关联对象编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.parent_bus_id is '父业务编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.parent_bus_descb is '父业务描述';
comment on column ${iml_schema}.agt_imp_fin_info_h.tran_oper_dt is '交易经办日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.tran_cmplt_dt is '交易完成日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.tran_descb is '交易描述';
comment on column ${iml_schema}.agt_imp_fin_info_h.tran_id is '交易编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_type_cd is '融资类型代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_amt_ratio is '融资金额比例';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_invo_cty_rg_cd is '融资涉及国家地区代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_curr_cd is '融资币种代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_status_cd is '融资状态代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_days is '融资天数';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_exp_dt is '融资到期日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.fin_rgst_dt is '融资登记日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.imp_fin_payfan_type_cd is '进口融资代付类型代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.payfan_nomal_int_rat is '代付正常利率';
comment on column ${iml_schema}.agt_imp_fin_info_h.payfan_value_dt is '代付起息日期';
comment on column ${iml_schema}.agt_imp_fin_info_h.bal_pay_type_cd is '收支类型代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.bal_pay_amt is '收支金额';
comment on column ${iml_schema}.agt_imp_fin_info_h.manuf_prd_type_cd is '制品类型代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.mtg_flg is '货押标志';
comment on column ${iml_schema}.agt_imp_fin_info_h.payfan_bus_breed_cd is '代付业务品种代码';
comment on column ${iml_schema}.agt_imp_fin_info_h.expect_payfan_int is '预估代付总利息';
comment on column ${iml_schema}.agt_imp_fin_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_imp_fin_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_imp_fin_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_imp_fin_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_imp_fin_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_imp_fin_info_h.etl_timestamp is 'ETL处理时间戳';
