/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_web_mall_merchd_sub_info_h_mrmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_web_mall_merchd_sub_info_h add partition p_mrmsi1 values ('mrmsi1')(
        subpartition p_mrmsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mrmsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_web_mall_merchd_sub_info_h partition for ('mrmsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_tm purge;
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_op purge;
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_descb -- 商品描述
    ,merchd_tot_qtty -- 商品总数量
    ,cors_merchd_tot_amt -- 对应商品总金额
    ,tran_type_cd -- 交易类型代码
    ,cors_merchd_tot_point -- 对应商品总积分
    ,rtn_goods_status_cd -- 退货状态代码
    ,tran_flow_num -- 交易流水号
    ,provi_name -- 供应商名称
    ,singl_merchd_comm_fee -- 单个商品手续费
    ,merchd_type_cd -- 商品类型代码
    ,tran_status_cd -- 交易状态代码
    ,indent_info_create_tm -- 订单信息创建时间
    ,indent_info_update_tm -- 订单信息更新时间
    ,addit_data_1 -- 附加数据1
    ,addit_data_2 -- 附加数据2
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_web_mall_merchd_sub_info_h partition for ('mrmsi1')
where 0=1
;

create table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_web_mall_merchd_sub_info_h partition for ('mrmsi1') where 0=1;

create table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_web_mall_merchd_sub_info_h partition for ('mrmsi1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_product_sub_info-
insert into ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_descb -- 商品描述
    ,merchd_tot_qtty -- 商品总数量
    ,cors_merchd_tot_amt -- 对应商品总金额
    ,tran_type_cd -- 交易类型代码
    ,cors_merchd_tot_point -- 对应商品总积分
    ,rtn_goods_status_cd -- 退货状态代码
    ,tran_flow_num -- 交易流水号
    ,provi_name -- 供应商名称
    ,singl_merchd_comm_fee -- 单个商品手续费
    ,merchd_type_cd -- 商品类型代码
    ,tran_status_cd -- 交易状态代码
    ,indent_info_create_tm -- 订单信息创建时间
    ,indent_info_update_tm -- 订单信息更新时间
    ,addit_data_1 -- 附加数据1
    ,addit_data_2 -- 附加数据2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104034'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 商品子订单流水号
    ,P1.KEY_RSP -- 订单流水号
    ,P1.PRODUCT_NO -- 商品编号
    ,case when P1.PRODUCT_TYPE='3' then '502060401' else '-' end  -- 标准产品编号
    ,P1.PRODUCT_NM -- 商品名称
    ,P1.PRODUCT_DESC -- 商品描述
    ,P1.PRODUCT_NUM -- 商品总数量
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRADE_MONEY, '[0-9.]+')),0)) -- 对应商品总金额
    ,NVL(TRIM(P1.TRADE_TYPE),'-') -- 交易类型代码
    ,P1.TRADE_POINT -- 对应商品总积分
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.UNDO_REFUND_FLAG END -- 退货状态代码
    ,P1.ORDER_NO -- 交易流水号
    ,P1.PROVI_NAME -- 供应商名称
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FORM_MRCHD_FEE, '[0-9.]+')),0)) -- 单个商品手续费
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PRODUCT_TYPE END -- 商品类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TXN_STA END -- 交易状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.CREATE_TIME) -- 订单信息创建时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.UPDATE_TIME) -- 订单信息更新时间
    ,P1.ADDDATA1 -- 附加数据1
    ,P1.ADDDATA2 -- 附加数据2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_product_sub_info' -- 源表名称
    ,'mrmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_product_sub_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.UNDO_REFUND_FLAG= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_PRODUCT_SUB_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'UNDO_REFUND_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_WEB_MALL_MERCHD_SUB_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'RTN_GOODS_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRODUCT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MRMS'
        AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_PRODUCT_SUB_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'PRODUCT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_WEB_MALL_MERCHD_SUB_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'MERCHD_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TXN_STA= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MRMS'
        AND R3.SRC_TAB_EN_NAME= 'MRMS_TBL_PRODUCT_SUB_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'TXN_STA'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_WEB_MALL_MERCHD_SUB_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND SUBSTR(P1.UPDATE_TIME,1,8)='${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_descb -- 商品描述
    ,merchd_tot_qtty -- 商品总数量
    ,cors_merchd_tot_amt -- 对应商品总金额
    ,tran_type_cd -- 交易类型代码
    ,cors_merchd_tot_point -- 对应商品总积分
    ,rtn_goods_status_cd -- 退货状态代码
    ,tran_flow_num -- 交易流水号
    ,provi_name -- 供应商名称
    ,singl_merchd_comm_fee -- 单个商品手续费
    ,merchd_type_cd -- 商品类型代码
    ,tran_status_cd -- 交易状态代码
    ,indent_info_create_tm -- 订单信息创建时间
    ,indent_info_update_tm -- 订单信息更新时间
    ,addit_data_1 -- 附加数据1
    ,addit_data_2 -- 附加数据2
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.evt_id -- 事件编号
    ,n.lp_id -- 法人编号
    ,n.merchd_sub_flow_num -- 商品子订单流水号
    ,n.indent_flow_num -- 订单流水号
    ,n.merchd_id -- 商品编号
    ,n.std_prod_id -- 标准产品编号
    ,n.merchd_name -- 商品名称
    ,n.merchd_descb -- 商品描述
    ,n.merchd_tot_qtty -- 商品总数量
    ,n.cors_merchd_tot_amt -- 对应商品总金额
    ,n.tran_type_cd -- 交易类型代码
    ,n.cors_merchd_tot_point -- 对应商品总积分
    ,n.rtn_goods_status_cd -- 退货状态代码
    ,n.tran_flow_num -- 交易流水号
    ,n.provi_name -- 供应商名称
    ,n.singl_merchd_comm_fee -- 单个商品手续费
    ,n.merchd_type_cd -- 商品类型代码
    ,n.tran_status_cd -- 交易状态代码
    ,n.indent_info_create_tm -- 订单信息创建时间
    ,n.indent_info_update_tm -- 订单信息更新时间
    ,n.addit_data_1 -- 附加数据1
    ,n.addit_data_2 -- 附加数据2
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'mrmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_tm n
    left join (select * from ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        o.merchd_sub_flow_num <> n.merchd_sub_flow_num
        or o.indent_flow_num <> n.indent_flow_num
        or o.merchd_id <> n.merchd_id
        or o.std_prod_id <> n.std_prod_id
        or o.merchd_name <> n.merchd_name
        or o.merchd_descb <> n.merchd_descb
        or o.merchd_tot_qtty <> n.merchd_tot_qtty
        or o.cors_merchd_tot_amt <> n.cors_merchd_tot_amt
        or o.tran_type_cd <> n.tran_type_cd
        or o.cors_merchd_tot_point <> n.cors_merchd_tot_point
        or o.rtn_goods_status_cd <> n.rtn_goods_status_cd
        or o.tran_flow_num <> n.tran_flow_num
        or o.provi_name <> n.provi_name
        or o.singl_merchd_comm_fee <> n.singl_merchd_comm_fee
        or o.merchd_type_cd <> n.merchd_type_cd
        or o.tran_status_cd <> n.tran_status_cd
        or o.indent_info_create_tm <> n.indent_info_create_tm
        or o.indent_info_update_tm <> n.indent_info_update_tm
        or o.addit_data_1 <> n.addit_data_1
        or o.addit_data_2 <> n.addit_data_2
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_descb -- 商品描述
    ,merchd_tot_qtty -- 商品总数量
    ,cors_merchd_tot_amt -- 对应商品总金额
    ,tran_type_cd -- 交易类型代码
    ,cors_merchd_tot_point -- 对应商品总积分
    ,rtn_goods_status_cd -- 退货状态代码
    ,tran_flow_num -- 交易流水号
    ,provi_name -- 供应商名称
    ,singl_merchd_comm_fee -- 单个商品手续费
    ,merchd_type_cd -- 商品类型代码
    ,tran_status_cd -- 交易状态代码
    ,indent_info_create_tm -- 订单信息创建时间
    ,indent_info_update_tm -- 订单信息更新时间
    ,addit_data_1 -- 附加数据1
    ,addit_data_2 -- 附加数据2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,merchd_sub_flow_num -- 商品子订单流水号
    ,indent_flow_num -- 订单流水号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_descb -- 商品描述
    ,merchd_tot_qtty -- 商品总数量
    ,cors_merchd_tot_amt -- 对应商品总金额
    ,tran_type_cd -- 交易类型代码
    ,cors_merchd_tot_point -- 对应商品总积分
    ,rtn_goods_status_cd -- 退货状态代码
    ,tran_flow_num -- 交易流水号
    ,provi_name -- 供应商名称
    ,singl_merchd_comm_fee -- 单个商品手续费
    ,merchd_type_cd -- 商品类型代码
    ,tran_status_cd -- 交易状态代码
    ,indent_info_create_tm -- 订单信息创建时间
    ,indent_info_update_tm -- 订单信息更新时间
    ,addit_data_1 -- 附加数据1
    ,addit_data_2 -- 附加数据2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.merchd_sub_flow_num -- 商品子订单流水号
    ,o.indent_flow_num -- 订单流水号
    ,o.merchd_id -- 商品编号
    ,o.std_prod_id -- 标准产品编号
    ,o.merchd_name -- 商品名称
    ,o.merchd_descb -- 商品描述
    ,o.merchd_tot_qtty -- 商品总数量
    ,o.cors_merchd_tot_amt -- 对应商品总金额
    ,o.tran_type_cd -- 交易类型代码
    ,o.cors_merchd_tot_point -- 对应商品总积分
    ,o.rtn_goods_status_cd -- 退货状态代码
    ,o.tran_flow_num -- 交易流水号
    ,o.provi_name -- 供应商名称
    ,o.singl_merchd_comm_fee -- 单个商品手续费
    ,o.merchd_type_cd -- 商品类型代码
    ,o.tran_status_cd -- 交易状态代码
    ,o.indent_info_create_tm -- 订单信息创建时间
    ,o.indent_info_update_tm -- 订单信息更新时间
    ,o.addit_data_1 -- 附加数据1
    ,o.addit_data_2 -- 附加数据2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_bk o
    left join ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_web_mall_merchd_sub_info_h;
alter table ${iml_schema}.evt_web_mall_merchd_sub_info_h truncate partition for ('mrmsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_web_mall_merchd_sub_info_h exchange subpartition p_mrmsi1_19000101 with table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_cl;
alter table ${iml_schema}.evt_web_mall_merchd_sub_info_h exchange subpartition p_mrmsi1_20991231 with table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_web_mall_merchd_sub_info_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_tm purge;
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_op purge;
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_web_mall_merchd_sub_info_h_mrmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_web_mall_merchd_sub_info_h', partname => 'p_mrmsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
