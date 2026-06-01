/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pais_agt_dacct_rela
CreateDate: 20180515
FileType:   DML
Logs:
    xzh 2018-05-15 新建表本
    20221215 徐子豪 新建脚本特殊加工二、三类户给个人结算账户，包含历史删除的二、三类户数据。
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.pais_agt_dacct_rela drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.pais_agt_dacct_rela add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 drop tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.pais_agt_dacct_rela_ex purge;
drop table ${idl_schema}.pais_agt_dacct_rela_01 purge;

-- 2.3 create table for exchage
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.pais_agt_dacct_rela_ex
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.pais_agt_dacct_rela where 0=1;

create table ${idl_schema}.pais_agt_dacct_rela_01
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.pais_agt_dacct_rela where 0=1;


-- 2.4 insert data target table
whenever sqlerror exit sql.sqlcode;
--第一组（共二组）
insert /*+ append */ into ${idl_schema}.pais_agt_dacct_rela_ex(
        etl_dt                            --数据日期
       ,acct_id                           --账户编号
       ,cust_acct_id                      --客户账户编号
       ,stl_cust_acct_num                 --结算客户账号
       ,open_acct_bank_fin_inst_id        --开户银行金融机构编号
       ,del_flg                           --删除标志
       ,job_cd                            --任务代码
       ,etl_timestamp                     --任务处理时间
        )
  select
       to_date('${batch_date}','yyyymmdd')                                                --数据日期
       ,t2.acct_id                                                                        --账户编号
       ,t2.cust_acct_id                                                                   --客户账户编号
       ,t1.stl_cust_acct_num                                                              --结算客户账号
       ,t1.open_acct_bank_fin_inst_id                                                     --开户银行金融机构编号
       ,'0'                                                                               --删除标志
       ,t1.job_cd                                                                         --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                   --任务处理时间
    from ${iml_schema}.agt_dep_acct_stl_info_h t1  --存款账户结算信息历史
  inner join ${icl_schema}.cmm_dep_acct_info t2
     on t1.acct_id = t2.acct_id
    and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
  where t2.acct_type_cd in ('2', '3') --过滤出账户等于2,3的
    and t1.stl_acct_cls_cd = 'REL'
    and t1.start_dt<=to_date('${batch_date}','yyyymmdd')
    and t1.end_dt>to_date('${batch_date}','yyyymmdd');

commit;


-- 2.5 insert data target table
whenever sqlerror exit sql.sqlcode;
--第二组（共二组）
--个人结算报送系统需要用到删除的数据
insert /*+ append */ into ${idl_schema}.pais_agt_dacct_rela_01(
        etl_dt                            --数据日期
       ,acct_id                           --账户编号
       ,cust_acct_id                      --客户账户编号
       ,stl_cust_acct_num                 --结算客户账号
       ,open_acct_bank_fin_inst_id        --开户银行金融机构编号
       ,del_flg                           --删除标志
       ,job_cd                            --任务代码
       ,etl_timestamp                     --任务处理时间
        )
  select
       to_date('${batch_date}','yyyymmdd')                                                --数据日期
       ,t1.acct_id                                                                        --账户编号
       ,t1.cust_acct_id                                                                   --客户账户编号
       ,t1.stl_cust_acct_num                                                              --结算客户账号
       ,t1.open_acct_bank_fin_inst_id                                                     --开户银行金融机构编号
       ,'1'                                                                               --删除标志
       ,t1.job_cd                                                                         --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                   --任务处理时间
      from ${idl_schema}.pais_agt_dacct_rela t1  --存款账户关系
  left join ${idl_schema}.pais_agt_dacct_rela_ex t2
       on t1.acct_id = t2.acct_id
      and t1.cust_acct_id=t2.cust_acct_id
      and t1.stl_cust_acct_num=t2.stl_cust_acct_num
      and t1.open_acct_bank_fin_inst_id=t2.open_acct_bank_fin_inst_id
    where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
      and t1.del_flg = '0'
      and t2.acct_id is null;

commit;


-- 2.6 insert data target table
whenever sqlerror exit sql.sqlcode;
--汇总插入目标表
insert /*+ append */ into ${idl_schema}.pais_agt_dacct_rela(
        etl_dt                            --数据日期
       ,acct_id                           --账户编号
       ,cust_acct_id                      --客户账户编号
       ,stl_cust_acct_num                 --结算客户账号
       ,open_acct_bank_fin_inst_id        --开户银行金融机构编号
       ,del_flg                           --删除标志
       ,job_cd                            --任务代码
       ,etl_timestamp                     --任务处理时间
        )
  select
        t1.etl_dt                            --数据日期
       ,t1.acct_id                           --账户编号
       ,t1.cust_acct_id                      --客户账户编号
       ,t1.stl_cust_acct_num                 --结算客户账号
       ,t1.open_acct_bank_fin_inst_id        --开户银行金融机构编号
       ,t1.del_flg                           --删除标志
       ,t1.job_cd                            --任务代码
       ,t1.etl_timestamp                     --任务处理时间
  from ${idl_schema}.pais_agt_dacct_rela_ex t1
    union all
  select
        t1.etl_dt                            --数据日期
       ,t1.acct_id                           --账户编号
       ,t1.cust_acct_id                      --客户账户编号
       ,t1.stl_cust_acct_num                 --结算客户账号
       ,t1.open_acct_bank_fin_inst_id        --开户银行金融机构编号
       ,t1.del_flg                           --删除标志
       ,t1.job_cd                            --任务代码
       ,t1.etl_timestamp                     --任务处理时间
   from ${idl_schema}.pais_agt_dacct_rela_01 t1
   union all
     select
        to_date('${batch_date}','yyyymmdd')  --数据日期
       ,t1.acct_id                           --账户编号
       ,t1.cust_acct_id                      --客户账户编号
       ,t1.stl_cust_acct_num                 --结算客户账号
       ,t1.open_acct_bank_fin_inst_id        --开户银行金融机构编号
       ,t1.del_flg                           --删除标志
       ,t1.job_cd                            --任务代码
       ,t1.etl_timestamp                     --任务处理时间
   from ${idl_schema}.pais_agt_dacct_rela t1
   where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1 
     and t1.del_flg = '1'
   ;

commit;


-- 2.7 drop ex table
drop table ${idl_schema}.pais_agt_dacct_rela_ex purge;
drop table ${idl_schema}.pais_agt_dacct_rela_01 purge;


-- 2.8 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pais_agt_dacct_rela',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);