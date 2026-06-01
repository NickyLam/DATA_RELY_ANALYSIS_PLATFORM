/*
Purpose:    共性加工层-验印账户基本信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_seal_acct_basic_info
Createdate: 20200910
Logs:       
     20210830  何桐金  调整【验印种类代码SEAL_KIND_CD、预警标志代码WARN_FLG_CD、交易种类代码TRAN_KIND_CD、睡眠户标志SLEEP_ACCT_FLG】字段逻辑，因M层将字段删除掉故此处将其调整为'-'
                       M层agt_check_conf_acct_info该表原为全量快照改为全量拉链，故C层需同步调整
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_seal_acct_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_seal_acct_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_seal_acct_basic_info_ex purge;


whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_seal_acct_basic_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_seal_acct_basic_info where 0=1
;
commit;



-- 第一组（共一组）验印系统账户信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_seal_acct_basic_info_ex(
    etl_dt		        --数据日期
    ,lp_id		        --法人编号
    ,cust_acct_id		--客户账户编号
    ,acct_name		    --账户名称
    ,open_acct_dt		--开户日期
    ,acct_start_use_dt	--账户启用日期
    ,acct_wrtoff_dt		--账户注销日期
    ,seal_kind_cd		--验印种类代码
    ,acct_status_cd		--账户状态代码
    ,warn_flg_cd		--预警标志代码
    ,pt_type_cd		    --支付工具类型代码
    ,acct_kind_cd		--账户种类代码
    ,tran_kind_cd		--交易种类代码
    ,curr_cd		    --币种代码
    ,unite_acct_flg		--联合账户标志
    ,sleep_acct_flg		--睡眠户标志
    ,open_acct_org_id	--开户机构编号
    ,oper_teller_id		--操作柜员编号
    ,check_teller_id	--复核柜员编号
    ,cotas_name		    --联系人名称
    ,cont_addr		    --联系地址
    ,phone_num		    --联系电话号码
    ,job_cd             --任务代码
    ,etl_timestamp      --ETL处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')	   as 	etl_dt		        --数据日期
   ,t1.lp_id	                           as 	lp_id		        --法人编号
   ,t1.acct_id	                           as 	cust_acct_id		--客户账户编号
   ,t1.acct_name	                       as 	acct_name		    --账户名称
   ,t1.open_acct_dt	                       as 	open_acct_dt		--开户日期
   ,t1.acct_start_use_dt	               as 	acct_start_use_dt	--账户启用日期
   ,t1.acct_wrtoff_dt	                   as 	acct_wrtoff_dt		--账户注销日期
   ,'-'	                                 as 	seal_kind_cd		--验印种类代码
   ,t1.acct_status_cd	                   as 	acct_status_cd		--账户状态代码
   ,'-'	                                 as 	warn_flg_cd		    --预警标志代码
   ,t1.pt_type_cd	                       as 	pt_type_cd   		--账户类型代码
   ,t1.acct_type_cd	                       as 	acct_kind_cd		--账户种类代码
   ,'-'	                                 as 	tran_kind_cd		--交易种类代码
   ,t1.curr_cd	                           as 	curr_cd		        --币种代码
   ,t1.unite_acct_flg	                   as 	unite_acct_flg		--联合账户标志
   ,'-'	                               as 	sleep_acct_flg		--睡眠户标志
   ,t1.brac_id	                           as 	open_acct_org_id	--开户机构编号
   ,t1.oper_teller_id	                   as 	oper_teller_id		--操作柜员编号
   ,t1.check_teller_id	                   as 	check_teller_id		--复核柜员编号
   ,t1.cotas_name	                       as 	cotas_name		    --联系人名称
   ,t1.cotas_addr	                       as 	cont_addr		    --联系地址
   ,t1.tel_num	                           as 	phone_num		    --联系电话号码
   ,t1.job_cd                              as   job_cd              --任务代码    
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') --ETL处理时间戳
from ${iml_schema}.agt_check_conf_acct_info t1
where t1.start_dt<= to_date('${batch_date}','yyyymmdd')	
  and t1.end_dt> to_date('${batch_date}','yyyymmdd')	
  and t1.job_cd = 'svssf1'
-- and t1.id_mark <> 'D'
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_seal_acct_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_seal_acct_basic_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_seal_acct_basic_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_seal_acct_basic_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
