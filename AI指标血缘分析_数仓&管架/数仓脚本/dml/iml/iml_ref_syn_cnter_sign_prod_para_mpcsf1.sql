/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_syn_cnter_sign_prod_para_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_syn_cnter_sign_prod_para add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_syn_cnter_sign_prod_para modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_syn_cnter_sign_prod_para partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_tm
compress ${option_switch} for query high
as
select
    sign_agt_cd -- 签约协议代码
    ,lp_id -- 法人编号
    ,agt_name -- 协议名称
    ,sign_way_cd -- 签约方式代码
    ,realtm_sync_flg -- 实时同步标志
    ,sell_obj_cd -- 销售对象代码
    ,sign_obj_permit_cd -- 签约对象许可代码
    ,auto_change_card_cd -- 自动换卡代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_syn_cnter_sign_prod_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_syn_cnter_sign_prod_para partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a02tcontractinfo-
insert into ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_tm(
    sign_agt_cd -- 签约协议代码
    ,lp_id -- 法人编号
    ,agt_name -- 协议名称
    ,sign_way_cd -- 签约方式代码
    ,realtm_sync_flg -- 实时同步标志
    ,sell_obj_cd -- 销售对象代码
    ,sign_obj_permit_cd -- 签约对象许可代码
    ,auto_change_card_cd -- 自动换卡代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CONTRACTNO -- 签约协议代码
    ,'9999' -- 法人编号
    ,P1.CONTRACTNAME -- 协议名称
    ,nvl(trim(P1.CONTRACTTYPE),'-') -- 签约方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CONTRACTUPDFLAG END -- 实时同步标志
    ,nvl(trim(P1.ALLOWCUSTTYPE),'0') -- 销售对象代码
    ,nvl(trim(P1.OUTBRCFLAG),'-') -- 签约对象许可代码
    ,nvl(trim(P1.CHANGEFLAG),'-') -- 自动换卡代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a02tcontractinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a02tcontractinfo p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CONTRACTUPDFLAG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A02TCONTRACTINFO'
        AND R3.SRC_FIELD_EN_NAME= 'CONTRACTUPDFLAG'
        AND R3.TARGET_TAB_EN_NAME= 'REF_SYN_CNTER_SIGN_PROD_PARA'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'REALTM_SYNC_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_tm 
  	                                group by 
  	                                        sign_agt_cd
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_ex(
    sign_agt_cd -- 签约协议代码
    ,lp_id -- 法人编号
    ,agt_name -- 协议名称
    ,sign_way_cd -- 签约方式代码
    ,realtm_sync_flg -- 实时同步标志
    ,sell_obj_cd -- 销售对象代码
    ,sign_obj_permit_cd -- 签约对象许可代码
    ,auto_change_card_cd -- 自动换卡代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.sign_agt_cd, o.sign_agt_cd) as sign_agt_cd -- 签约协议代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.agt_name, o.agt_name) as agt_name -- 协议名称
    ,nvl(n.sign_way_cd, o.sign_way_cd) as sign_way_cd -- 签约方式代码
    ,nvl(n.realtm_sync_flg, o.realtm_sync_flg) as realtm_sync_flg -- 实时同步标志
    ,nvl(n.sell_obj_cd, o.sell_obj_cd) as sell_obj_cd -- 销售对象代码
    ,nvl(n.sign_obj_permit_cd, o.sign_obj_permit_cd) as sign_obj_permit_cd -- 签约对象许可代码
    ,nvl(n.auto_change_card_cd, o.auto_change_card_cd) as auto_change_card_cd -- 自动换卡代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.sign_agt_cd is null
                and o.lp_id is null
            ) or (
                o.agt_name <> n.agt_name
                or o.sign_way_cd <> n.sign_way_cd
                or o.realtm_sync_flg <> n.realtm_sync_flg
                or o.sell_obj_cd <> n.sell_obj_cd
                or o.sign_obj_permit_cd <> n.sign_obj_permit_cd
                or o.auto_change_card_cd <> n.auto_change_card_cd
            ) or (
                 case when (
                           n.sign_agt_cd is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.sign_agt_cd is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_tm n
    full join ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_bk o
        on
            o.sign_agt_cd = n.sign_agt_cd
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_syn_cnter_sign_prod_para truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_syn_cnter_sign_prod_para exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_syn_cnter_sign_prod_para drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_syn_cnter_sign_prod_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_ex purge;
drop table ${iml_schema}.ref_syn_cnter_sign_prod_para_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_syn_cnter_sign_prod_para', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);