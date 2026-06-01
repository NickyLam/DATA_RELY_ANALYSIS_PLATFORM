/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_fdl_idx_index_data_jx
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
    zhengpeilong 2021-07-26 修改装数条件，每次重跑绩效7天数据
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
-- alter table ${itl_schema}.mtl_fdl_idx_index_data_jx drop partition p_${retain_day};  20200901去除删除策略，保留全部
alter table ${itl_schema}.mtl_fdl_idx_index_data_jx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_fdl_idx_index_data_jx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 get new data into table
/*
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 6 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mtl_fdl_idx_index_data_jx'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table mtl_fdl_idx_index_data_jx truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table mtl_fdl_idx_index_data_jx add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/
*/


-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_fdl_idx_index_data_jx  (
    index_no -- 指标编号
    ,org_no -- 机构编号
    ,biz_strip_line_cd -- 业务条线代码
    ,dim_cd1 -- 维度代码1
    ,dim_cd2 -- 维度代码2
    ,dim_cd3 -- 维度代码3
    ,batch_freq -- 批次频度
    ,index_measure -- 指标度量
    ,curr_cd -- 币种代码
    ,index_val -- 指标值
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(index_no), ' ') as index_no -- 指标编号
    ,nvl(trim(org_no), ' ') as org_no -- 机构编号
    ,nvl(trim(biz_strip_line_cd), ' ') as biz_strip_line_cd -- 业务条线代码
    ,nvl(trim(dim_cd1), ' ') as dim_cd1 -- 维度代码1
    ,nvl(trim(dim_cd2), ' ') as dim_cd2 -- 维度代码2
    ,nvl(trim(dim_cd3), ' ') as dim_cd3 -- 维度代码3
    ,nvl(trim(batch_freq), ' ') as batch_freq -- 批次频度
    ,nvl(trim(index_measure), ' ') as index_measure -- 指标度量
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(index_val), 0) as index_val -- 指标值
    --,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,etl_dt as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_fdl_idx_index_data_jx
where 1 = 1
 --and etl_dt >= to_date('${batch_date}','yyyymmdd')-6
 --and etl_dt <= to_date('${batch_date}','yyyymmdd') 
 and etl_dt = to_date('${batch_date}','yyyymmdd') 
 and (substr(index_no,1,2) = 'JX'
 or index_no IN ('FM0100364'
,'FM0100365'
,'FM0100366'
,'FM0500425'
,'FM0500426'
,'FM0500427'
,'FM0500428'))
 ;
commit;
delete mtl_fdl_idx_index_data_jx where index_no in (
'JXI0000001',
'JXI0000004',
'JXI0000006',
'JXI0000007',
'JXI0000008',
'JXI0000014',
'JXI0000019',
'JXI0000023',
'JXI0000024'
) and etl_dt=to_date('${batch_date}','yyyymmdd') and org_no='000000';
commit;
MERGE INTO mtl_fdl_idx_index_data_jx a
USING (SELECT * FROM mtl_fdl_idx_index_data WHERE index_no in (
'FM0100002',
'FM0100354',
'FM0100006',
'FM0100054',
'FM0100060',
'FM0100063',
'FM0500069',
'FM0500013',
'FM0500022'
) and etl_dt=to_date('${batch_date}','yyyymmdd') and org_no='000000') b
ON (a.index_no = b.index_no AND a.org_no = b.org_no AND a.curr_cd = b.curr_cd AND a.etl_dt = b.etl_dt)
WHEN NOT MATCHED THEN
    INSERT
        (index_no -- 指标编号
        ,org_no -- 机构编号
        ,batch_freq -- 批次频度
        ,index_measure -- 指标度量
        ,curr_cd -- 币种代码
        ,index_val -- 指标值
        ,etl_dt -- ETL处理日期
        ,etl_timestamp -- ETL处理时间
		)
    VALUES
        (
		decode(b.index_no,
		'FM0100002','JXI0000001',
		'FM0100354','JXI0000004',
		'FM0100006','JXI0000006',
		'FM0100054','JXI0000007',
		'FM0100060','JXI0000008',
		'FM0100063','JXI0000014',
		'FM0500069','JXI0000019',
		'FM0500013','JXI0000023',
		'FM0500022','JXI0000024')
        ,b.org_no
		,'M'
		,b.INDEX_MEASURE
        ,b.curr_cd
        ,coalesce(b.INDEX_VAL,0)
        ,to_date('${batch_date}','yyyymmdd')
        ,b.etl_timestamp) 
        WHERE b.etl_dt = to_date('${batch_date}','yyyymmdd');
COMMIT;


-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_fdl_idx_index_data_jx to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_fdl_idx_index_data_jx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);