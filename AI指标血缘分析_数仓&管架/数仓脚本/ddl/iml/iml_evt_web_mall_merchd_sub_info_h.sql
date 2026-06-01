/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_web_mall_merchd_sub_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_web_mall_merchd_sub_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_web_mall_merchd_sub_info_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,merchd_sub_flow_num varchar2(100) -- 商品子订单流水号
    ,indent_flow_num varchar2(100) -- 订单流水号
    ,merchd_id varchar2(100) -- 商品编号
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,merchd_name varchar2(375) -- 商品名称
    ,merchd_descb varchar2(1500) -- 商品描述
    ,merchd_tot_qtty varchar2(30) -- 商品总数量
    ,cors_merchd_tot_amt number(30,2) -- 对应商品总金额
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,cors_merchd_tot_point varchar2(30) -- 对应商品总积分
    ,rtn_goods_status_cd varchar2(30) -- 退货状态代码
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,provi_name varchar2(375) -- 供应商名称
    ,singl_merchd_comm_fee number(30,2) -- 单个商品手续费
    ,merchd_type_cd varchar2(30) -- 商品类型代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,indent_info_create_tm date -- 订单信息创建时间
    ,indent_info_update_tm date -- 订单信息更新时间
    ,addit_data_1 varchar2(150) -- 附加数据1
    ,addit_data_2 varchar2(150) -- 附加数据2
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
grant select on ${iml_schema}.evt_web_mall_merchd_sub_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_web_mall_merchd_sub_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_web_mall_merchd_sub_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_web_mall_merchd_sub_info_h is '网上商城商品子订单信息历史';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.merchd_sub_flow_num is '商品子订单流水号';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.indent_flow_num is '订单流水号';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.merchd_id is '商品编号';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.merchd_name is '商品名称';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.merchd_descb is '商品描述';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.merchd_tot_qtty is '商品总数量';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.cors_merchd_tot_amt is '对应商品总金额';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.cors_merchd_tot_point is '对应商品总积分';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.rtn_goods_status_cd is '退货状态代码';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.provi_name is '供应商名称';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.singl_merchd_comm_fee is '单个商品手续费';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.merchd_type_cd is '商品类型代码';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.indent_info_create_tm is '订单信息创建时间';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.indent_info_update_tm is '订单信息更新时间';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.addit_data_1 is '附加数据1';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.addit_data_2 is '附加数据2';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_web_mall_merchd_sub_info_h.etl_timestamp is 'ETL处理时间戳';
