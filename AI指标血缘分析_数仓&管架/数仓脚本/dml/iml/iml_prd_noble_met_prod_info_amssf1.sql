/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_noble_met_prod_info_amssf1
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
alter table ${iml_schema}.prd_noble_met_prod_info add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_noble_met_prod_info_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_noble_met_prod_info partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_noble_met_prod_info_amssf1_tm purge;
drop table ${iml_schema}.prd_noble_met_prod_info_amssf1_op purge;
drop table ${iml_schema}.prd_noble_met_prod_info_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_noble_met_prod_info_amssf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_brand -- 商品品牌
    ,provi_name -- 供应商名称
    ,merchd_type_cd -- 商品类型代码
    ,merchd_cls_cd -- 商品分类代码
    ,goods_id -- 货品编号
    ,prod_fine -- 产品成色
    ,prod_gold_ct -- 产品含金量
    ,prod_artm_ct -- 产品含银量
    ,prod_matrl -- 产品材质
    ,craft -- 工艺
    ,weight_corp -- 重量单位
    ,weight -- 重量
    ,measure -- 尺寸
    ,prod_price -- 产品单价
    ,prod_qtty -- 产品数量
    ,prod_comm_fee_rule -- 产品手续费规则
    ,sell_lmt_qtty -- 销售限制数量
    ,prod_status_cd -- 产品状态代码
    ,grounding_tm -- 上架时间
    ,under_carige_tm -- 下架时间
    ,prod_info_create_tm -- 产品信息创建时间
    ,prod_info_update_tm -- 产品信息更新时间
    ,addit_data_1 -- 附加数据1
    ,addit_data_2 -- 附加数据2
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_noble_met_prod_info partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.prd_noble_met_prod_info_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_noble_met_prod_info partition for ('amssf1') where 0=1;

create table ${iml_schema}.prd_noble_met_prod_info_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_noble_met_prod_info partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_tbl_product_info_detail_his-
insert into ${iml_schema}.prd_noble_met_prod_info_amssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_brand -- 商品品牌
    ,provi_name -- 供应商名称
    ,merchd_type_cd -- 商品类型代码
    ,merchd_cls_cd -- 商品分类代码
    ,goods_id -- 货品编号
    ,prod_fine -- 产品成色
    ,prod_gold_ct -- 产品含金量
    ,prod_artm_ct -- 产品含银量
    ,prod_matrl -- 产品材质
    ,craft -- 工艺
    ,weight_corp -- 重量单位
    ,weight -- 重量
    ,measure -- 尺寸
    ,prod_price -- 产品单价
    ,prod_qtty -- 产品数量
    ,prod_comm_fee_rule -- 产品手续费规则
    ,sell_lmt_qtty -- 销售限制数量
    ,prod_status_cd -- 产品状态代码
    ,grounding_tm -- 上架时间
    ,under_carige_tm -- 下架时间
    ,prod_info_create_tm -- 产品信息创建时间
    ,prod_info_update_tm -- 产品信息更新时间
    ,addit_data_1 -- 附加数据1
    ,addit_data_2 -- 附加数据2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224001'||P1.ID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.ID -- 序列号
    ,P1.PRODUCT_NO -- 商品编号
    ,case when P1.PRODUCT_TYPE='贵金属商品' then '502060401' else '-' end  -- 标准产品编号
    ,P1.PRODUCT_NM -- 商品名称
    ,P1.PRODUCT_BRAND -- 商品品牌
    ,P1.SUPPLIER_NM -- 供应商名称
    ,P1.PRODUCT_TYPE -- 商品类型代码
    ,P1.PRODUCT_SORT -- 商品分类代码
    ,P1.PRODUCT_SERIAL_NO -- 货品编号
    ,P1.PRODUCT_QUALITY -- 产品成色
    ,P1.PERCENT_GOLD -- 产品含金量
    ,P1.PERCENT_SILVER -- 产品含银量
    ,P1.PRODUCT_MATERIAL -- 产品材质
    ,P1.PRODUCT_TECHNOLOGY -- 工艺
    ,P1.WEIGHT_UNIT -- 重量单位
    ,P1.WEIGHT -- 重量
    ,P1.PRODUCT_SIZE -- 尺寸
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.PRODUCT_UNIT_PRICE, '[0-9.]+')),0)) -- 产品单价
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.PRODUCT_NUM, '[0-9.]+')),0)) -- 产品数量
    ,P1.PRODUCT_CHARGE -- 产品手续费规则
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.SALE_LIMITED_NUM, '[0-9.]+')),0)) -- 销售限制数量
    ,P1.PRODUCT_STATUS -- 产品状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.ONSALE_TIME) -- 上架时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.OFFSHELVES_TIME) -- 下架时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.CREATE_TIME) -- 产品信息创建时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.UPDATE_TIME) -- 产品信息更新时间
    ,P1.ADDDATA1 -- 附加数据1
    ,P1.ADDDATA2 -- 附加数据2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_tbl_product_info_detail_his' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_tbl_product_info_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_noble_met_prod_info_amssf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_noble_met_prod_info_amssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_brand -- 商品品牌
    ,provi_name -- 供应商名称
    ,merchd_type_cd -- 商品类型代码
    ,merchd_cls_cd -- 商品分类代码
    ,goods_id -- 货品编号
    ,prod_fine -- 产品成色
    ,prod_gold_ct -- 产品含金量
    ,prod_artm_ct -- 产品含银量
    ,prod_matrl -- 产品材质
    ,craft -- 工艺
    ,weight_corp -- 重量单位
    ,weight -- 重量
    ,measure -- 尺寸
    ,prod_price -- 产品单价
    ,prod_qtty -- 产品数量
    ,prod_comm_fee_rule -- 产品手续费规则
    ,sell_lmt_qtty -- 销售限制数量
    ,prod_status_cd -- 产品状态代码
    ,grounding_tm -- 上架时间
    ,under_carige_tm -- 下架时间
    ,prod_info_create_tm -- 产品信息创建时间
    ,prod_info_update_tm -- 产品信息更新时间
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
        into ${iml_schema}.prd_noble_met_prod_info_amssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_brand -- 商品品牌
    ,provi_name -- 供应商名称
    ,merchd_type_cd -- 商品类型代码
    ,merchd_cls_cd -- 商品分类代码
    ,goods_id -- 货品编号
    ,prod_fine -- 产品成色
    ,prod_gold_ct -- 产品含金量
    ,prod_artm_ct -- 产品含银量
    ,prod_matrl -- 产品材质
    ,craft -- 工艺
    ,weight_corp -- 重量单位
    ,weight -- 重量
    ,measure -- 尺寸
    ,prod_price -- 产品单价
    ,prod_qtty -- 产品数量
    ,prod_comm_fee_rule -- 产品手续费规则
    ,sell_lmt_qtty -- 销售限制数量
    ,prod_status_cd -- 产品状态代码
    ,grounding_tm -- 上架时间
    ,under_carige_tm -- 下架时间
    ,prod_info_create_tm -- 产品信息创建时间
    ,prod_info_update_tm -- 产品信息更新时间
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
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.merchd_id, o.merchd_id) as merchd_id -- 商品编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.merchd_name, o.merchd_name) as merchd_name -- 商品名称
    ,nvl(n.merchd_brand, o.merchd_brand) as merchd_brand -- 商品品牌
    ,nvl(n.provi_name, o.provi_name) as provi_name -- 供应商名称
    ,nvl(n.merchd_type_cd, o.merchd_type_cd) as merchd_type_cd -- 商品类型代码
    ,nvl(n.merchd_cls_cd, o.merchd_cls_cd) as merchd_cls_cd -- 商品分类代码
    ,nvl(n.goods_id, o.goods_id) as goods_id -- 货品编号
    ,nvl(n.prod_fine, o.prod_fine) as prod_fine -- 产品成色
    ,nvl(n.prod_gold_ct, o.prod_gold_ct) as prod_gold_ct -- 产品含金量
    ,nvl(n.prod_artm_ct, o.prod_artm_ct) as prod_artm_ct -- 产品含银量
    ,nvl(n.prod_matrl, o.prod_matrl) as prod_matrl -- 产品材质
    ,nvl(n.craft, o.craft) as craft -- 工艺
    ,nvl(n.weight_corp, o.weight_corp) as weight_corp -- 重量单位
    ,nvl(n.weight, o.weight) as weight -- 重量
    ,nvl(n.measure, o.measure) as measure -- 尺寸
    ,nvl(n.prod_price, o.prod_price) as prod_price -- 产品单价
    ,nvl(n.prod_qtty, o.prod_qtty) as prod_qtty -- 产品数量
    ,nvl(n.prod_comm_fee_rule, o.prod_comm_fee_rule) as prod_comm_fee_rule -- 产品手续费规则
    ,nvl(n.sell_lmt_qtty, o.sell_lmt_qtty) as sell_lmt_qtty -- 销售限制数量
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,nvl(n.grounding_tm, o.grounding_tm) as grounding_tm -- 上架时间
    ,nvl(n.under_carige_tm, o.under_carige_tm) as under_carige_tm -- 下架时间
    ,nvl(n.prod_info_create_tm, o.prod_info_create_tm) as prod_info_create_tm -- 产品信息创建时间
    ,nvl(n.prod_info_update_tm, o.prod_info_update_tm) as prod_info_update_tm -- 产品信息更新时间
    ,nvl(n.addit_data_1, o.addit_data_1) as addit_data_1 -- 附加数据1
    ,nvl(n.addit_data_2, o.addit_data_2) as addit_data_2 -- 附加数据2
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_noble_met_prod_info_amssf1_tm n
    full join (select * from ${iml_schema}.prd_noble_met_prod_info_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.lp_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
    )
    or (
        o.ser_num <> n.ser_num
        or o.merchd_id <> n.merchd_id
        or o.std_prod_id <> n.std_prod_id
        or o.merchd_name <> n.merchd_name
        or o.merchd_brand <> n.merchd_brand
        or o.provi_name <> n.provi_name
        or o.merchd_type_cd <> n.merchd_type_cd
        or o.merchd_cls_cd <> n.merchd_cls_cd
        or o.goods_id <> n.goods_id
        or o.prod_fine <> n.prod_fine
        or o.prod_gold_ct <> n.prod_gold_ct
        or o.prod_artm_ct <> n.prod_artm_ct
        or o.prod_matrl <> n.prod_matrl
        or o.craft <> n.craft
        or o.weight_corp <> n.weight_corp
        or o.weight <> n.weight
        or o.measure <> n.measure
        or o.prod_price <> n.prod_price
        or o.prod_qtty <> n.prod_qtty
        or o.prod_comm_fee_rule <> n.prod_comm_fee_rule
        or o.sell_lmt_qtty <> n.sell_lmt_qtty
        or o.prod_status_cd <> n.prod_status_cd
        or o.grounding_tm <> n.grounding_tm
        or o.under_carige_tm <> n.under_carige_tm
        or o.prod_info_create_tm <> n.prod_info_create_tm
        or o.prod_info_update_tm <> n.prod_info_update_tm
        or o.addit_data_1 <> n.addit_data_1
        or o.addit_data_2 <> n.addit_data_2
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_noble_met_prod_info_amssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_brand -- 商品品牌
    ,provi_name -- 供应商名称
    ,merchd_type_cd -- 商品类型代码
    ,merchd_cls_cd -- 商品分类代码
    ,goods_id -- 货品编号
    ,prod_fine -- 产品成色
    ,prod_gold_ct -- 产品含金量
    ,prod_artm_ct -- 产品含银量
    ,prod_matrl -- 产品材质
    ,craft -- 工艺
    ,weight_corp -- 重量单位
    ,weight -- 重量
    ,measure -- 尺寸
    ,prod_price -- 产品单价
    ,prod_qtty -- 产品数量
    ,prod_comm_fee_rule -- 产品手续费规则
    ,sell_lmt_qtty -- 销售限制数量
    ,prod_status_cd -- 产品状态代码
    ,grounding_tm -- 上架时间
    ,under_carige_tm -- 下架时间
    ,prod_info_create_tm -- 产品信息创建时间
    ,prod_info_update_tm -- 产品信息更新时间
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
        into ${iml_schema}.prd_noble_met_prod_info_amssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,merchd_id -- 商品编号
    ,std_prod_id -- 标准产品编号
    ,merchd_name -- 商品名称
    ,merchd_brand -- 商品品牌
    ,provi_name -- 供应商名称
    ,merchd_type_cd -- 商品类型代码
    ,merchd_cls_cd -- 商品分类代码
    ,goods_id -- 货品编号
    ,prod_fine -- 产品成色
    ,prod_gold_ct -- 产品含金量
    ,prod_artm_ct -- 产品含银量
    ,prod_matrl -- 产品材质
    ,craft -- 工艺
    ,weight_corp -- 重量单位
    ,weight -- 重量
    ,measure -- 尺寸
    ,prod_price -- 产品单价
    ,prod_qtty -- 产品数量
    ,prod_comm_fee_rule -- 产品手续费规则
    ,sell_lmt_qtty -- 销售限制数量
    ,prod_status_cd -- 产品状态代码
    ,grounding_tm -- 上架时间
    ,under_carige_tm -- 下架时间
    ,prod_info_create_tm -- 产品信息创建时间
    ,prod_info_update_tm -- 产品信息更新时间
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
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.ser_num -- 序列号
    ,o.merchd_id -- 商品编号
    ,o.std_prod_id -- 标准产品编号
    ,o.merchd_name -- 商品名称
    ,o.merchd_brand -- 商品品牌
    ,o.provi_name -- 供应商名称
    ,o.merchd_type_cd -- 商品类型代码
    ,o.merchd_cls_cd -- 商品分类代码
    ,o.goods_id -- 货品编号
    ,o.prod_fine -- 产品成色
    ,o.prod_gold_ct -- 产品含金量
    ,o.prod_artm_ct -- 产品含银量
    ,o.prod_matrl -- 产品材质
    ,o.craft -- 工艺
    ,o.weight_corp -- 重量单位
    ,o.weight -- 重量
    ,o.measure -- 尺寸
    ,o.prod_price -- 产品单价
    ,o.prod_qtty -- 产品数量
    ,o.prod_comm_fee_rule -- 产品手续费规则
    ,o.sell_lmt_qtty -- 销售限制数量
    ,o.prod_status_cd -- 产品状态代码
    ,o.grounding_tm -- 上架时间
    ,o.under_carige_tm -- 下架时间
    ,o.prod_info_create_tm -- 产品信息创建时间
    ,o.prod_info_update_tm -- 产品信息更新时间
    ,o.addit_data_1 -- 附加数据1
    ,o.addit_data_2 -- 附加数据2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_noble_met_prod_info_amssf1_bk o
    left join ${iml_schema}.prd_noble_met_prod_info_amssf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_noble_met_prod_info_amssf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_noble_met_prod_info;
--alter table ${iml_schema}.prd_noble_met_prod_info truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_noble_met_prod_info') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_noble_met_prod_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_noble_met_prod_info modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_noble_met_prod_info exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.prd_noble_met_prod_info_amssf1_cl;
alter table ${iml_schema}.prd_noble_met_prod_info exchange subpartition p_amssf1_20991231 with table ${iml_schema}.prd_noble_met_prod_info_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_noble_met_prod_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_noble_met_prod_info_amssf1_tm purge;
drop table ${iml_schema}.prd_noble_met_prod_info_amssf1_op purge;
drop table ${iml_schema}.prd_noble_met_prod_info_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_noble_met_prod_info_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_noble_met_prod_info', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
