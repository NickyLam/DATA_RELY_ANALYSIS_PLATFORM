/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_make_card_appl_info_h_ncbsf1
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
alter table ${iml_schema}.agt_make_card_appl_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_make_card_appl_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,appl_dt -- 申请日期
    ,card_prod_id -- 卡产品编号
    ,card_corp_abbr -- 卡商简称
    ,make_card_dt -- 制卡日期
    ,make_card_type_cd -- 制卡类型代码
    ,make_card_appl_type_cd -- 制卡申请类型代码
    ,make_card_qtty -- 制卡数量
    ,make_card_status_cd -- 制卡状态代码
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,lucky_card_flg -- 吉祥卡标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,choice_num_type_cd -- 选号类型代码
    ,card_draw_way_cd -- 卡片领取方式代码
    ,recv_flg -- 签收标志
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_make_card_appl_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_make_card_appl_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_make_card_appl_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cd_make_card_reg-1
insert into ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,appl_dt -- 申请日期
    ,card_prod_id -- 卡产品编号
    ,card_corp_abbr -- 卡商简称
    ,make_card_dt -- 制卡日期
    ,make_card_type_cd -- 制卡类型代码
    ,make_card_appl_type_cd -- 制卡申请类型代码
    ,make_card_qtty -- 制卡数量
    ,make_card_status_cd -- 制卡状态代码
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,lucky_card_flg -- 吉祥卡标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,choice_num_type_cd -- 选号类型代码
    ,card_draw_way_cd -- 卡片领取方式代码
    ,recv_flg -- 签收标志
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101018'||P1.APPLY_NO -- 协议编号
    ,'9999' -- 法人编号
    ,'101018'||P1.APPLY_NO -- 申请编号
    ,P1.APPLY_DATE -- 申请日期
    ,P1.PROD_TYPE -- 卡产品编号
    ,P1.CARD_PROVIDER -- 卡商简称
    ,P1.MAKE_CARD_DATE -- 制卡日期
    ,P1.MAKE_CARD_TYPE -- 制卡类型代码
    ,nvl(trim(P1.CARD_APPLY_TYPE),'-') -- 制卡申请类型代码
    ,P1.CARD_NUM -- 制卡数量
    ,nvl(trim(P1.MAKE_CD_STATUS),'-') -- 制卡状态代码
    ,P1.BATCH_JOB_NO -- 制卡文件批次号
    ,nvl(trim(P1.AREA_CODE),'XXX') -- 预制卡国家和地区代码
    ,decode(trim(p1.LUCKY_CARD_FLAG),'','-','Y','1','N','0',p1.LUCKY_CARD_FLAG) -- 吉祥卡标志
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,nvl(trim(P1.PICK_TYPE),'-') -- 选号类型代码
    ,nvl(trim(P1.GAIN_TYPE),'-') -- 卡片领取方式代码
    ,NVL(TRIM(P1.RECEIVE_FLAG),'-') -- 签收标志
    ,P1.DOC_TYPE -- 存款凭证类别代码
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cd_make_card_reg' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cd_make_card_reg p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,appl_id
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
        into ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,appl_dt -- 申请日期
    ,card_prod_id -- 卡产品编号
    ,card_corp_abbr -- 卡商简称
    ,make_card_dt -- 制卡日期
    ,make_card_type_cd -- 制卡类型代码
    ,make_card_appl_type_cd -- 制卡申请类型代码
    ,make_card_qtty -- 制卡数量
    ,make_card_status_cd -- 制卡状态代码
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,lucky_card_flg -- 吉祥卡标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,choice_num_type_cd -- 选号类型代码
    ,card_draw_way_cd -- 卡片领取方式代码
    ,recv_flg -- 签收标志
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,appl_dt -- 申请日期
    ,card_prod_id -- 卡产品编号
    ,card_corp_abbr -- 卡商简称
    ,make_card_dt -- 制卡日期
    ,make_card_type_cd -- 制卡类型代码
    ,make_card_appl_type_cd -- 制卡申请类型代码
    ,make_card_qtty -- 制卡数量
    ,make_card_status_cd -- 制卡状态代码
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,lucky_card_flg -- 吉祥卡标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,choice_num_type_cd -- 选号类型代码
    ,card_draw_way_cd -- 卡片领取方式代码
    ,recv_flg -- 签收标志
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.card_prod_id, o.card_prod_id) as card_prod_id -- 卡产品编号
    ,nvl(n.card_corp_abbr, o.card_corp_abbr) as card_corp_abbr -- 卡商简称
    ,nvl(n.make_card_dt, o.make_card_dt) as make_card_dt -- 制卡日期
    ,nvl(n.make_card_type_cd, o.make_card_type_cd) as make_card_type_cd -- 制卡类型代码
    ,nvl(n.make_card_appl_type_cd, o.make_card_appl_type_cd) as make_card_appl_type_cd -- 制卡申请类型代码
    ,nvl(n.make_card_qtty, o.make_card_qtty) as make_card_qtty -- 制卡数量
    ,nvl(n.make_card_status_cd, o.make_card_status_cd) as make_card_status_cd -- 制卡状态代码
    ,nvl(n.make_card_doc_batch_no, o.make_card_doc_batch_no) as make_card_doc_batch_no -- 制卡文件批次号
    ,nvl(n.pre_make_card_cty_rg_cd, o.pre_make_card_cty_rg_cd) as pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,nvl(n.lucky_card_flg, o.lucky_card_flg) as lucky_card_flg -- 吉祥卡标志
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.choice_num_type_cd, o.choice_num_type_cd) as choice_num_type_cd -- 选号类型代码
    ,nvl(n.card_draw_way_cd, o.card_draw_way_cd) as card_draw_way_cd -- 卡片领取方式代码
    ,nvl(n.recv_flg, o.recv_flg) as recv_flg -- 签收标志
    ,nvl(n.dep_vouch_cate_cd, o.dep_vouch_cate_cd) as dep_vouch_cate_cd -- 存款凭证类别代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.appl_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.appl_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.appl_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.appl_id = n.appl_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.appl_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.appl_id is null
    )
    or (
        o.appl_dt <> n.appl_dt
        or o.card_prod_id <> n.card_prod_id
        or o.card_corp_abbr <> n.card_corp_abbr
        or o.make_card_dt <> n.make_card_dt
        or o.make_card_type_cd <> n.make_card_type_cd
        or o.make_card_appl_type_cd <> n.make_card_appl_type_cd
        or o.make_card_qtty <> n.make_card_qtty
        or o.make_card_status_cd <> n.make_card_status_cd
        or o.make_card_doc_batch_no <> n.make_card_doc_batch_no
        or o.pre_make_card_cty_rg_cd <> n.pre_make_card_cty_rg_cd
        or o.lucky_card_flg <> n.lucky_card_flg
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.tran_tm <> n.tran_tm
        or o.choice_num_type_cd <> n.choice_num_type_cd
        or o.card_draw_way_cd <> n.card_draw_way_cd
        or o.recv_flg <> n.recv_flg
        or o.dep_vouch_cate_cd <> n.dep_vouch_cate_cd
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,appl_dt -- 申请日期
    ,card_prod_id -- 卡产品编号
    ,card_corp_abbr -- 卡商简称
    ,make_card_dt -- 制卡日期
    ,make_card_type_cd -- 制卡类型代码
    ,make_card_appl_type_cd -- 制卡申请类型代码
    ,make_card_qtty -- 制卡数量
    ,make_card_status_cd -- 制卡状态代码
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,lucky_card_flg -- 吉祥卡标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,choice_num_type_cd -- 选号类型代码
    ,card_draw_way_cd -- 卡片领取方式代码
    ,recv_flg -- 签收标志
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,appl_dt -- 申请日期
    ,card_prod_id -- 卡产品编号
    ,card_corp_abbr -- 卡商简称
    ,make_card_dt -- 制卡日期
    ,make_card_type_cd -- 制卡类型代码
    ,make_card_appl_type_cd -- 制卡申请类型代码
    ,make_card_qtty -- 制卡数量
    ,make_card_status_cd -- 制卡状态代码
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,lucky_card_flg -- 吉祥卡标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,choice_num_type_cd -- 选号类型代码
    ,card_draw_way_cd -- 卡片领取方式代码
    ,recv_flg -- 签收标志
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.appl_id -- 申请编号
    ,o.appl_dt -- 申请日期
    ,o.card_prod_id -- 卡产品编号
    ,o.card_corp_abbr -- 卡商简称
    ,o.make_card_dt -- 制卡日期
    ,o.make_card_type_cd -- 制卡类型代码
    ,o.make_card_appl_type_cd -- 制卡申请类型代码
    ,o.make_card_qtty -- 制卡数量
    ,o.make_card_status_cd -- 制卡状态代码
    ,o.make_card_doc_batch_no -- 制卡文件批次号
    ,o.pre_make_card_cty_rg_cd -- 预制卡国家和地区代码
    ,o.lucky_card_flg -- 吉祥卡标志
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_tm -- 交易时间
    ,o.choice_num_type_cd -- 选号类型代码
    ,o.card_draw_way_cd -- 卡片领取方式代码
    ,o.recv_flg -- 签收标志
    ,o.dep_vouch_cate_cd -- 存款凭证类别代码
    ,o.remark -- 备注
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
from ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.appl_id = n.appl_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.appl_id = d.appl_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_make_card_appl_info_h;
--alter table ${iml_schema}.agt_make_card_appl_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_make_card_appl_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_make_card_appl_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_make_card_appl_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_make_card_appl_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_make_card_appl_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_make_card_appl_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_make_card_appl_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_make_card_appl_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
