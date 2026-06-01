/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_rela_h_eifsf1
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
alter table ${iml_schema}.pty_party_rela_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_rela_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rela_h partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_rela_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_rela_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_rela_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_rela_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_rela_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_party_rela_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rela_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_party_rela_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rela_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t00_party_pub_info-
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'dw005' -- 当事人关系类型代码
    ,'1'||LPAD('1',9,'0') -- 序号
    ,case when P1.Cust_Status_Cd='01' then ' ' else   P1.LAST_UPDATED_TE  end -- 关联当事人编号
    ,'1' -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_party_pub_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t00_party_pub_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- eifs_t00_party_pub_info-1
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'dw003' -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.CUST_MGR_NUM -- 关联当事人编号
    ,'1' -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_party_pub_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t00_party_pub_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and trim(P1.CUST_MGR_NUM) is not  null
;
commit;

-- eifs_t01_corp_group_info-
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GROUP_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'dw005' -- 当事人关系类型代码
    ,'1'||LPAD('1',9,'0') -- 序号
    ,case when P1.GROUP_STATUS='0' then ' ' else   P1.LAST_UPDATED_TE  end -- 关联当事人编号
    ,'1' -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_group_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_group_info p1
    left join ${iol_schema}.eifs_t00_party_pub_info p2 on P1.GROUP_NUM=P2.CUST_NUM AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND  p2.PARTY_ID is null
;
commit;

-- eifs_t01_corp_group_info-1
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GROUP_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'dw007' -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.PRNT_CUST_NO -- 关联当事人编号
    ,'1' -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_group_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_group_info p1
    left join ${iol_schema}.eifs_t00_party_pub_info p2 on P1.GROUP_NUM=P2.CUST_NUM AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND  p2.PARTY_ID is null and trim(PRNT_CUST_NO) is not null
;
commit;

-- eifs_t01_corp_group_info-2
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GROUP_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'dw003' -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.CUST_MGR_NUM -- 关联当事人编号
    ,'1' -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_group_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_group_info p1
    left join ${iol_schema}.eifs_t00_party_pub_info p2 on P1.GROUP_NUM=P2.CUST_NUM AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND  p2.PARTY_ID is null and trim(p1.CUST_MGR_NUM) is not null
;
commit;

-- eifs_t01_corp_group_members-
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BELONG_GROUP_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,decode(p1.Grcorp_Ind,'1','10111','10112') -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.MEM_CUST_NUM -- 关联当事人编号
    ,'1' -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_group_members' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_group_members p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P1.UPDATED_TS = to_timestamp('9999-12-31 00:00:00','YYYY-MM-DD HH24:MI:SS')
;
commit;

-- eifs_t01_corp_rel_corp_info-1
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.RELA_CUST_RELA_CD -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.REL_ENTERP_ID -- 关联当事人编号
    ,nvl(trim(P1.RELA_STAT_CD),'-')  -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_corp_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_corp_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
  --  AND TRIM(P1.RELA_NUM ) IS NOT NULL 
      AND p1.Updated_Ts=to_timestamp('9999-12-31 00:00:00','YYYY-MM-DD HH24:MI:SS')
;
commit;

-- eifs_t01_corp_rel_per_info-1
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.RELA_CUST_RELA_CD -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.REL_ID -- 关联当事人编号
    ,nvl(trim(P1.RELA_STAT_CD),'-') -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_per_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    --AND TRIM(P1.RELA_NUM ) IS NOT NULL 
    AND p1.Updated_Ts=to_timestamp('9999-12-31 00:00:00','YYYY-MM-DD HH24:MI:SS')
;
commit;

-- eifs_t01_per_cust_info-1
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'dw006' -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.EMPLY_NUM -- 关联当事人编号
    ,'1' -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_cust_info p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID
and P2.start_dt<=to_date('${batch_date}','yyyymmdd') and P2.end_dt>to_date('${batch_date}','yyyymmdd')  
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRIM(P1.EMPLY_NUM) IS NOT NULL  
;
commit;

-- eifs_t01_per_rel_per_info-1
insert into ${iml_schema}.pty_party_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.RELA_CUST_RELA_CD -- 当事人关系类型代码
    ,'1' -- 序号
    ,P1.REL_ID -- 关联当事人编号
    ,nvl(trim(P1.RELA_STAT_CD),'-') -- 关联关系状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_rel_per_info p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    --AND TRIM(P1.RELA_NUM ) IS NOT NULL 
    AND p1.Updated_Ts=to_timestamp('9999-12-31 00:00:00','YYYY-MM-DD HH24:MI:SS')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_rela_h_eifsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,party_rela_type_cd
  	                                        ,seq_num
  	                                        ,rela_party_id
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
        into ${iml_schema}.pty_party_rela_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_rela_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
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
    ,nvl(n.party_rela_type_cd, o.party_rela_type_cd) as party_rela_type_cd -- 当事人关系类型代码
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.rela_party_id, o.rela_party_id) as rela_party_id -- 关联当事人编号
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 关联关系状态代码
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.party_rela_type_cd is null
            and n.seq_num is null
            and n.rela_party_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.party_rela_type_cd is null
            and n.seq_num is null
            and n.rela_party_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.party_rela_type_cd is null
            and n.seq_num is null
            and n.rela_party_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_rela_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_party_rela_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.party_rela_type_cd = n.party_rela_type_cd
            and o.seq_num = n.seq_num
            and o.rela_party_id = n.rela_party_id
where (
        o.party_id is null
        and o.lp_id is null
        and o.party_rela_type_cd is null
        and o.seq_num is null
        and o.rela_party_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.party_rela_type_cd is null
        and n.seq_num is null
        and n.rela_party_id is null
    )
    or (
        o.valid_flg <> n.valid_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_rela_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_rela_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,seq_num -- 序号
    ,rela_party_id -- 关联当事人编号
    ,valid_flg -- 关联关系状态代码
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
    ,o.party_rela_type_cd -- 当事人关系类型代码
    ,o.seq_num -- 序号
    ,o.rela_party_id -- 关联当事人编号
    ,o.valid_flg -- 关联关系状态代码
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
from ${iml_schema}.pty_party_rela_h_eifsf1_bk o
    left join ${iml_schema}.pty_party_rela_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.party_rela_type_cd = n.party_rela_type_cd
            and o.seq_num = n.seq_num
            and o.rela_party_id = n.rela_party_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_rela_h_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.party_rela_type_cd = d.party_rela_type_cd
            and o.seq_num = d.seq_num
            and o.rela_party_id = d.rela_party_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_rela_h;
--alter table ${iml_schema}.pty_party_rela_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_rela_h modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

whenever sqlerror exit sql.sqlcode;
-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_rela_h exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_party_rela_h_eifsf1_cl;
alter table ${iml_schema}.pty_party_rela_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_party_rela_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_rela_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_rela_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_rela_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_rela_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_rela_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
