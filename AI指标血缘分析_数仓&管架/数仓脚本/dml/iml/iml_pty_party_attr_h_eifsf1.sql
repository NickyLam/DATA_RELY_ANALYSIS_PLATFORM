/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_attr_h_eifsf1
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
alter table ${iml_schema}.pty_party_attr_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_attr_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_attr_h partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_attr_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_attr_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_attr_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_attr_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_attr_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_party_attr_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_attr_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_party_attr_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_attr_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t00_party_pub_info-1
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'B0002' -- 属性类型代码
    ,CASE WHEN P1.DOM_FORGN_CD='2' THEN '0' WHEN TRIM(P1.DOM_FORGN_CD) IS NULL THEN '-' ELSE P1.DOM_FORGN_CD END  -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_party_pub_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t00_party_pub_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND  TRIM(P1.DOM_FORGN_CD) IS NOT NULL
;
commit;

-- eifs_t01_corp_cust_ext_info-4
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'B0005' -- 属性类型代码
    ,CASE WHEN TRIM(P1.TECHNOLOGY_ORG_TYPE) IS NULL THEN '-'
     WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL 
     ELSE '@'||P1.TECHNOLOGY_ORG_TYPE END -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY party_id ORDER BY updated_ts DESC) RN
               FROM ${iol_schema}.eifs_t01_corp_cust_ext_info T
					     where t.start_dt<= to_date('${batch_date}','yyyymmdd') 
               and t.end_dt > to_date('${batch_date}','yyyymmdd')) p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TECHNOLOGY_ORG_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'EIFS2'
        AND R1.SRC_TAB_EN_NAME= 'EIFS_T01_CORP_CUST_EXT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'TECHNOLOGY_ORG_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_PARTY_ATTR_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ATTR_VAL'
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID
and p2.start_dt<=to_date('${batch_date}','yyyymmdd') and p2.end_dt>to_date('${batch_date}','yyyymmdd')
where p1.rn=1
-- and p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND trim(p2.party_id) is not null 
;
commit;

-- eifs_t01_corp_cust_info-3
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'CD2436' -- 属性类型代码
    ,NVL(TRIM(P1.SELF_SUP_FLAG),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRIM(P2.PARTY_ID) IS NOT NULL
;
commit;

-- eifs_t01_corp_cust_info-4
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'CD2437' -- 属性类型代码
    ,NVL(TRIM(P1.LOAN_FLAG),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRIM(P2.PARTY_ID) IS NOT NULL
;
commit;

-- eifs_t01_corp_cust_info-5
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'CD2438' -- 属性类型代码
    ,NVL(TRIM(P1.GUARANTEE_FLAG),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRIM(P2.PARTY_ID) IS NOT NULL
;
commit;

-- eifs_t01_per_cust_ext_info-1
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'I0001' -- 属性类型代码
    ,P1.INTERESTS -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY party_id ORDER BY updated_ts DESC) RN
               FROM ${iol_schema}.eifs_t01_per_cust_ext_info T
					     where t.start_dt<= to_date('${batch_date}','yyyymmdd') 
               and t.end_dt > to_date('${batch_date}','yyyymmdd')) p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.rn=1
-- and p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND  TRIM(P1.INTERESTS) IS NOT NULL 
;
commit;

-- eifs_t01_per_cust_info-2
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'CD2436' -- 属性类型代码
    ,NVL(TRIM(P1.SELF_SUP_FLAG),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_cust_info p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRIM(P2.PARTY_ID) IS NOT NULL
;
commit;

-- eifs_t01_per_cust_info-3
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'CD2437' -- 属性类型代码
    ,NVL(TRIM(P1.LOAN_FLAG),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_cust_info p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRIM(P2.PARTY_ID) IS NOT NULL
;
commit;

-- eifs_t01_per_cust_info-4
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'CD2438' -- 属性类型代码
    ,NVL(TRIM(P1.GUARANTEE_FLAG),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_cust_info p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRIM(P2.PARTY_ID) IS NOT NULL
;
commit;

-- eifs_t08_corp_cust_tag_info-
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,p1.LABEL_TYPE_CD -- 属性类型代码
    ,nvl(trim(p1.LABEL_VALUE),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t08_corp_cust_tag_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t08_corp_cust_tag_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID
and p2.start_dt<=to_date('${batch_date}','yyyymmdd') and p2.end_dt>to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND trim(p2.party_id) is not null 
;
commit;

-- eifs_t08_per_cust_tag_info-
insert into ${iml_schema}.pty_party_attr_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,p1.LABEL_TYPE_CD -- 属性类型代码
    ,nvl(trim(p1.LABEL_VALUE),'-') -- 属性值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t08_per_cust_tag_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t08_per_cust_tag_info p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID
and p2.start_dt<=to_date('${batch_date}','yyyymmdd') and p2.end_dt>to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND trim(p2.party_id) is not null 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_attr_h_eifsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,attr_name
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
        into ${iml_schema}.pty_party_attr_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_attr_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.attr_name, o.attr_name) as attr_name -- 属性类型代码
    ,nvl(n.attr_val, o.attr_val) as attr_val -- 属性值
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.attr_name is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.attr_name is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.attr_name is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_attr_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_party_attr_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.attr_name = n.attr_name
where (
        o.party_id is null
        and o.lp_id is null
        and o.attr_name is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.attr_name is null
    )
    or (
        o.attr_val <> n.attr_val
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_attr_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_attr_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性类型代码
    ,attr_val -- 属性值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.attr_name -- 属性类型代码
    ,o.attr_val -- 属性值
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
from ${iml_schema}.pty_party_attr_h_eifsf1_bk o
    left join ${iml_schema}.pty_party_attr_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.attr_name = n.attr_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_attr_h_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.attr_name = d.attr_name
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_attr_h;
--alter table ${iml_schema}.pty_party_attr_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_attr_h') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_attr_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_attr_h modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_attr_h exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_party_attr_h_eifsf1_cl;
alter table ${iml_schema}.pty_party_attr_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_party_attr_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_attr_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_attr_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_attr_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_attr_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_attr_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_attr_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
