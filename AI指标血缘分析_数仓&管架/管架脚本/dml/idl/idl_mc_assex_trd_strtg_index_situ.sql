/*
Purpose:    IDL-考核模块三化指标情况
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_assex_trd_strtg_index_situ
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_assex_trd_strtg_index_situ
    表中文名： 考核模块三化指标情况
    创建日期： None
    主键字段： 数据日期
    归属层次： IDL
    归属主题： None
    分区粒度： 
    分析人员： None
    时间粒度： 日
    保留周期： 永久
    描述信息： None
    更新记录:
        2026-01-22    郑沛隆    新建脚本    
                    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_assex_trd_strtg_index_situ add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mc_assex_trd_strtg_index_situ truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--考核模块三化指标情况:插入目标表
insert into ${idl_schema}.mc_assex_trd_strtg_index_situ(
    seq_num                                                      --序号
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    -- 5
    ,label_key                                                   --标签键
    ,label_key_desc                                              --标签键描述
    ,label_value                                                 --标签值
    ,unit                                                        --单位
    ,sort_flg                                                    --排序标志
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.SEQ_NUM as seq_num                                        --序号
    ,t1.INDEX_NO as index_no                                     --指标编号
    ,t1.INDEX_NAME as index_name                                 --指标名称
    ,t1.ORG_NO as org_no                                         --机构编号
    ,t2.org_name as org_name                                     --机构名称
    -- 5
    ,t1.LABEL_KEY as label_key                                   --标签键
    ,t1.LABEL_KEY_DESC as label_key_desc                         --标签键描述
    ,t1.LABEL_VALUE as label_value                               --标签值
    ,t1.UNIT as unit                                             --单位
    ,case when t1.index_name='零售获客批量化' and t1.seq_num>=3 and t1.seq_num<=6 then '是' end as sort_flg --排序标志
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_assex_trd_strtg_index_situ_bl t1 --考核模块三化指标情况 
LEFT JOIN mc_orga_para_jxkh t2 --绩效考核机构表 
 on t1.org_no=t2.org_no
and t2.org_level in ('分行','事业部','条线管理部门','全行')

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_assex_trd_strtg_index_situ', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cAScade => true);
