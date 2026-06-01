/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_point_mall_pay_mec_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_point_mall_pay_mec_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_point_mall_pay_mec_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_point_mall_pay_mec_info(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,merchd_sub_indent_flow_num varchar2(100) -- 商品子订单流水号
    ,indent_flow_num varchar2(100) -- 订单流水号
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,provi_name varchar2(500) -- 供应商名称
    ,merchd_id varchar2(100) -- 商品编号
    ,merchd_name varchar2(500) -- 商品名称
    ,merchd_tot_qtty number(10) -- 商品总数量
    ,merchd_descb varchar2(500) -- 商品描述
    ,single_merchd_comm_fee number(10) -- 单个商品手续费
    ,valid_flg varchar2(10) -- 有效标志
    ,final_update_dt date -- 最后更新日期
    ,create_teller_id varchar2(100) -- 创建柜员编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
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
grant select on ${iml_schema}.evt_point_mall_pay_mec_info to ${icl_schema};
grant select on ${iml_schema}.evt_point_mall_pay_mec_info to ${idl_schema};
grant select on ${iml_schema}.evt_point_mall_pay_mec_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_point_mall_pay_mec_info is '积分商城订单商品信息';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.merchd_sub_indent_flow_num is '商品子订单流水号';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.indent_flow_num is '订单流水号';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.provi_name is '供应商名称';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.merchd_id is '商品编号';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.merchd_name is '商品名称';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.merchd_tot_qtty is '商品总数量';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.merchd_descb is '商品描述';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.single_merchd_comm_fee is '单个商品手续费';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.valid_flg is '有效标志';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.create_teller_id is '创建柜员编号';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.start_dt is '开始时间';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.end_dt is '结束时间';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.id_mark is '增删标志';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_point_mall_pay_mec_info.etl_timestamp is 'ETL处理时间戳';
