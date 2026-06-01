--python $ETL_HOME/script/main.py yyyymmdd idl_mc_level5_cls_dtl
set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.mc_level5_cls_dtl_${batch_date}_tm purge ;
alter table ${idl_schema}.mc_level5_cls_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_level5_cls_dtl_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.mc_level5_cls_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table

--RM0200214	全行不良贷款额
INSERT INTO ${idl_schema}.mc_level5_cls_dtl_${batch_date}_tm
    (index_no
    ,index_name
    ,belong_brch --varchar2(200) -- 所属分行
    ,asset_cate --varchar2(50) -- 资产类别
    ,cust_name --varchar2(200) -- 客户名称
    ,belong_group --varchar2(500) -- 所属集团
    ,bus_breed --varchar2(500) -- 业务品种
    ,bus_bal --number(28,4) -- 业务余额
    ,level5_cls --varchar2(50) -- 五级分类
    ,sort_seq_num --number(38) -- 排序序号
    ,etl_dt --date -- ETL处理日期
    ,etl_timestamp --timestamp -- ETL处理时间戳
     )

    SELECT 
          'RM0200214'
          ,'全行不良贷款额'
          ,replace(t1.belong_brch,'广东华兴银行股份有限公司','')
          ,t1.asset_cate
          ,case when t1.asset_cate like '%非零售%' then t1.cust_name else '/' end
          ,case when t1.asset_cate like '%非零售%' then t1.belong_group else '/' end
          ,case when t1.asset_cate like '%非零售%' then t1.bus_breed else '/' end
          ,sum(t1.bus_bal)
          ,t1.level5_cls
          ,rank() over(PARTITION BY t2.org_no ORDER BY t2.org_no)
					,to_date('${batch_date}','yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   itl_rdw_rdw_mcs_level5_cls_dtl t1
    inner join mc_orga_para t2
        on t1.belong_brch=t2.org_name
    where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
    	and t1.level5_cls in ('次级', '可疑', '损失')
      and t1.asset_cate in ('非零售贷款','零售贷款')
      group by replace(t1.belong_brch,'广东华兴银行股份有限公司','')
      				,t1.asset_cate
          		,case when t1.asset_cate like '%非零售%' then t1.cust_name else '/' end
          		,case when t1.asset_cate like '%非零售%' then t1.belong_group else '/' end
          		,case when t1.asset_cate like '%非零售%' then t1.bus_breed else '/' end
          		,t1.level5_cls
COMMIT;



-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.mc_level5_cls_dtl truncate partition p_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.mc_level5_cls_dtl exchange partition p_${batch_date} with table ${idl_schema}.mc_level5_cls_dtl_${batch_date}_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.mc_level5_cls_dtl to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.mc_level5_cls_dtl_${batch_date}_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mc_level5_cls_dtl', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);