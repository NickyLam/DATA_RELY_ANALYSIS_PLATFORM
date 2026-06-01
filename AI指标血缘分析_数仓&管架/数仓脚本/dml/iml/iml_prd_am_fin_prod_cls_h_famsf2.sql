/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_fin_prod_cls_h_famsf2
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
alter table ${iml_schema}.prd_am_fin_prod_cls_h add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_famsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_fin_prod_cls_h partition for ('famsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_tm nologging
compress ${option_switch} for query high
as select
    fin_prod_id -- 金融产品编号
    ,lp_id -- 法人编号
    ,brch_seq_num -- 分支序号
    ,bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,std_prod_id -- 标准产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_fin_prod_cls_h partition for ('famsf2')
where 0=1
;

create table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_fin_prod_cls_h partition for ('famsf2') where 0=1;

create table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_fin_prod_cls_h partition for ('famsf2') where 0=1;

-- 3.1 get new data into table
-- fams_fin_product_type-1
insert into ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_tm(
    fin_prod_id -- 金融产品编号
    ,lp_id -- 法人编号
    ,brch_seq_num -- 分支序号
    ,bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,std_prod_id -- 标准产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.FINPROD_ID -- 金融产品编号
    ,'9999' -- 法人编号
    ,P1.BRANCH -- 分支序号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TYPE_9 END -- 行内产品二级分类代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TYPE_10 END -- 行内产品三级分类代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TYPE_11 END -- 行内产品四级分类代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.TYPE_12 END -- 行内产品五级分类代码
    ,p1.STD_PROD_ID -- 标准产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_product_type' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product_type p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TYPE_9 = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT_TYPE'
        AND R1.SRC_FIELD_EN_NAME= 'TYPE_9'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_FIN_PROD_CLS_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BANK_INT_PROD_LEVEL2_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TYPE_10 = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT_TYPE'
        AND R2.SRC_FIELD_EN_NAME= 'TYPE_10'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_AM_FIN_PROD_CLS_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BANK_INT_PROD_LEVEL3_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TYPE_11 = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT_TYPE'
        AND R3.SRC_FIELD_EN_NAME= 'TYPE_11'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_AM_FIN_PROD_CLS_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BANK_INT_PROD_LEVEL4_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TYPE_12 = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT_TYPE'
        AND R4.SRC_FIELD_EN_NAME= 'TYPE_12'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_AM_FIN_PROD_CLS_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'BANK_INT_PROD_LEVEL5_CLS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_cl(
            fin_prod_id -- 金融产品编号
    ,lp_id -- 法人编号
    ,brch_seq_num -- 分支序号
    ,bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_op(
            fin_prod_id -- 金融产品编号
    ,lp_id -- 法人编号
    ,brch_seq_num -- 分支序号
    ,bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.brch_seq_num, o.brch_seq_num) as brch_seq_num -- 分支序号
    ,nvl(n.bank_int_prod_level2_cls_cd, o.bank_int_prod_level2_cls_cd) as bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,nvl(n.bank_int_prod_level3_cls_cd, o.bank_int_prod_level3_cls_cd) as bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,nvl(n.bank_int_prod_level4_cls_cd, o.bank_int_prod_level4_cls_cd) as bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,nvl(n.bank_int_prod_level5_cls_cd, o.bank_int_prod_level5_cls_cd) as bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,case when
            n.fin_prod_id is null
            and n.lp_id is null
            and n.brch_seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fin_prod_id is null
            and n.lp_id is null
            and n.brch_seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fin_prod_id is null
            and n.lp_id is null
            and n.brch_seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_tm n
    full join (select * from ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_prod_id = n.fin_prod_id
            and o.lp_id = n.lp_id
            and o.brch_seq_num = n.brch_seq_num
where (
        o.fin_prod_id is null
        and o.lp_id is null
        and o.brch_seq_num is null
    )
    or (
        n.fin_prod_id is null
        and n.lp_id is null
        and n.brch_seq_num is null
    )
    or (
        o.bank_int_prod_level2_cls_cd <> n.bank_int_prod_level2_cls_cd
        or o.bank_int_prod_level3_cls_cd <> n.bank_int_prod_level3_cls_cd
        or o.bank_int_prod_level4_cls_cd <> n.bank_int_prod_level4_cls_cd
        or o.bank_int_prod_level5_cls_cd <> n.bank_int_prod_level5_cls_cd
        or o.std_prod_id <> n.std_prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_cl(
            fin_prod_id -- 金融产品编号
    ,lp_id -- 法人编号
    ,brch_seq_num -- 分支序号
    ,bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_op(
            fin_prod_id -- 金融产品编号
    ,lp_id -- 法人编号
    ,brch_seq_num -- 分支序号
    ,bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fin_prod_id -- 金融产品编号
    ,o.lp_id -- 法人编号
    ,o.brch_seq_num -- 分支序号
    ,o.bank_int_prod_level2_cls_cd -- 行内产品二级分类代码
    ,o.bank_int_prod_level3_cls_cd -- 行内产品三级分类代码
    ,o.bank_int_prod_level4_cls_cd -- 行内产品四级分类代码
    ,o.bank_int_prod_level5_cls_cd -- 行内产品五级分类代码
    ,o.std_prod_id -- 标准产品编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_bk o
    left join ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_op n
        on
            o.fin_prod_id = n.fin_prod_id
            and o.lp_id = n.lp_id
            and o.brch_seq_num = n.brch_seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_cl d
        on
            o.fin_prod_id = d.fin_prod_id
            and o.lp_id = d.lp_id
            and o.brch_seq_num = d.brch_seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_am_fin_prod_cls_h;
alter table ${iml_schema}.prd_am_fin_prod_cls_h truncate partition for ('famsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_am_fin_prod_cls_h exchange subpartition p_famsf2_19000101 with table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_cl;
alter table ${iml_schema}.prd_am_fin_prod_cls_h exchange subpartition p_famsf2_20991231 with table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_fin_prod_cls_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_tm purge;
drop table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_op purge;
drop table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_am_fin_prod_cls_h_famsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_fin_prod_cls_h', partname => 'p_famsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
