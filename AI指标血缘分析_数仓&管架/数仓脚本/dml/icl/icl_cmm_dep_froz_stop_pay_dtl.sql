/*
Purpose:    共性加工层-存款账户冻结止付明细主表：数据主要来源于核心和中台系统，包括电信诈骗止付流水、公安查控止付流水、国安查控止付流水、高院划扣流水、司法止付流水等各种司法查冻扣明细。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_dep_froz_stop_pay_dtl
logs:20200412 翟若平 增加字段【客户编号】、调整部分字段顺序、表名调整为存款账户冻结止付明细							
     20200430 翟若平 增加字段【查控系统编号、查控系统名称、查控性质】							
     20220315 翟若平 增加字段【执行人名称2】	
     20220429 翟若平 1、调整字段【渠道代码】的取数口径
                     2、增加字段【审批柜员编号、授权柜员编号】	
     20220518 温旺清 表名更改：evt_dep_acct_lmt_dtl ->agt_dep_acct_lmt_info_h	
     20220606 温旺清 新增字段【旧子户编号】	 
     20220724 李森辉 1、调整字段【冻结止付日期】
                     2、调整T2和T3表的关联条件，以及T1临时表的过滤条件
     20221027 温旺清 新增字段【冻结止付时间戳】
     20221124 温旺清 新增字段【存款分户编号】
     20240606 陈伟峰 调整acct_name截取逻辑，按150位截取,froz_rs按300位截取
     20240624 陈伟峰 调整acct_name截取逻辑，按140位截取,froz_rs按290位截取
     20251216 陈伟峰 调整字段【执行机关名称EXEC_ORG_NAME、客户名称CUST_NAME】长度为VARCHAR2(500)
*/
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_froz_stop_pay_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_dep_froz_stop_pay_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_01 purge;
drop table ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_02 purge;
drop table ${icl_schema}.cmm_dep_froz_stop_pay_dtl_ex purge;

whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_01
nologging
compress ${option_switch} for query high
as
select
	t2.frozsq
	,t2.frozdt
    ,t2.type_cd
    ,t2.inv_ctrl_sys_id
    ,t2.inv_ctrl_sys_name
    ,t2.inv_ctrl_char
  from (select hostseqno as frozsq,
                       hostdt as frozdt,
                       '01' as type_cd,
                       'DXCK' as inv_ctrl_sys_id,
                       '电信诈骗网络查控系统' as inv_ctrl_sys_name,
                       '控' as inv_ctrl_char
                  from ${iol_schema}.mpcs_a0tbfreezefb a1
                 where txcode = '100202'
                   and trim(hostseqno) is not null
                   and a1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and a1.end_dt > to_date('${batch_date}', 'yyyymmdd') ---电信诈骗冻结流水号和日期
                union all
                select hostseqno as frozsq,
                       hostdt as frozdt,
                       '03' as type_cd,
                       'GACK' as inv_ctrl_sys_id,
                       '银行业金融机构与监察机关开展账户资金网络查控' as inv_ctrl_sys_name,
                       '控' as inv_ctrl_char
                  from ${iol_schema}.mpcs_a1atyhxzdjmx a2
                 inner join ${iol_schema}.mpcs_a1atyhxzdj b2
                    on a2.rwlsh = b2.rwlsh
                   and b2.tradetype = '1'
                   and b2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and b2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 where trim(a2.hostseqno) is not null --公安查控冻结流水号和日期
                   and a2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and a2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                union all
                select hostseqno as frozsq,
                       hostdt as frozdt,
                       '05' as type_cd,
                       'GGCK' as inv_ctrl_sys_id,
                       '银行业金融机构与国家安全机关开展涉案账户资金网络查控系统' as inv_ctrl_sys_name,
                       '控' as inv_ctrl_char
                  from ${iol_schema}.mpcs_a1btyhxzdjmx a3
                 inner join ${iol_schema}.mpcs_a1btyhxzdj b3
                    on a3.rwlsh = b3.rwlsh
                   and b3.tradetype = '1'
                   and b3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and b3.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 where trim(a3.hostseqno) is not null --国安查控冻结流水号和日期
                   and a3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and a3.end_dt > to_date('${batch_date}', 'yyyymmdd')
                union all
                select hostseqno as frozsq,
                       hostdt as frozdt,
                       '07' as type_cd,
                       'GYCK' as inv_ctrl_sys_id,
                       '最高人民法院涉案账户资金网络查控系统' as inv_ctrl_sys_name,
                       '控' as inv_ctrl_char
                  from ${iol_schema}.mpcs_a0ptkzcljg a4
                 inner join ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo b4
                    on a4.bdhm = b4.bdhm
                   and b4.kzcs = '01'
                   and b4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and b4.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 where trim(a4.hostseqno) is not null --高院冻结流水号和日期
                   and a4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and a4.end_dt > to_date('${batch_date}', 'yyyymmdd')
                union all
                select hostseqno as frozsq,
                       hostdt as frozdt,
                       '09' as type_cd,
                       (case
                         when b5.xtbz = 'GDJC' then
                          'GDJC'
                         else
                          'GACD'
                       end) as inv_ctrl_sys_id,
                       (case
                         when b5.xtbz = 'GDJC' then
                          '广东省检察院查冻系统'
                         else
                          '广东省公安厅查冻系统'
                       end) as inv_ctrl_sys_name,
                       '控' as inv_ctrl_char
                  from ${iol_schema}.mpcs_a77tfreezeqryfk a5
                 inner join ${iol_schema}.mpcs_a77tfreezeqryusracct b5
                    on a5.uniqueid = b5.uniqueid
                   and b5.frotype = '1'
                   and b5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and b5.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 where trim(a5.hostseqno) is not null
                   and a5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and a5.end_dt > to_date('${batch_date}', 'yyyymmdd')) t2--司法冻结流水
;
create table ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_02
nologging
compress ${option_switch} for query high
as
select
		t3.transq
		,t3.frozdt
	 	,t3.type_cd
	 	,t3.inv_ctrl_sys_id
	 	,t3.inv_ctrl_sys_name
	 	,t3.inv_ctrl_char
	from (select hostnbr as transq
							,hostdate as frozdt
							,'02' as type_cd
							,'DXCK' as inv_ctrl_sys_id
       				,'电信诈骗网络查控系统' as inv_ctrl_sys_name
       				,'控' as inv_ctrl_char
					from ${iol_schema}.mpcs_a0tacctzf a1 
				 where txcode='100101'
				 	 and trim(hostnbr) is not null
					 and a1.start_dt<=to_date('${batch_date}','yyyymmdd')
					 and a1.end_dt>to_date('${batch_date}','yyyymmdd') ---电信诈骗止付流水号和日期
				 union all
				select hostseqno as transq
							,hostdt as frozdt
							,'04' as type_cd
							,'GACK' as inv_ctrl_sys_id
       				,'银行业金融机构与监察机关开展账户资金网络查控' as inv_ctrl_sys_name
       				,'控' as inv_ctrl_char
					from ${iol_schema}.mpcs_a1atyhjjzfmx a2
				 	inner join ${iol_schema}.mpcs_a1atyhjjzf b2
				 		 on a2.rwlsh = b2.rwlsh
				 		and b2.tradetype = '1'
				 		and b2.start_dt<=to_date('${batch_date}','yyyymmdd')
				 		and b2.end_dt>to_date('${batch_date}','yyyymmdd')
				 		and a2.start_dt<=to_date('${batch_date}','yyyymmdd')
				 		and a2.end_dt>to_date('${batch_date}','yyyymmdd')
				 	where trim(a2.hostseqno) is not null --公安查控止付流水号和日期
				 union all
				select hostseqno as transq
							,hostdt as frozdt
							,'06' as type_cd
							,'GGCK' as inv_ctrl_sys_id
       				,'银行业金融机构与国家安全机关开展涉案账户资金网络查控系统' as inv_ctrl_sys_name
       				,'控' as inv_ctrl_char
					from ${iol_schema}.mpcs_a1btyhjjzfmx a3
					inner join ${iol_schema}.mpcs_a1btyhjjzf b3
						 on a3.rwlsh = b3.rwlsh
						and b3.tradetype = '1'
						and b3.start_dt<=to_date('${batch_date}','yyyymmdd')
						and b3.end_dt>to_date('${batch_date}','yyyymmdd')
						and a3.start_dt<=to_date('${batch_date}','yyyymmdd')
						and a3.end_dt>to_date('${batch_date}','yyyymmdd')
					where trim(a3.hostseqno) is not null --国安查控止付流水号和日期
				union all
			 select hostseqno as transq
			 			 ,hostdt as frozdt
			 			 ,'08' as type_cd
			 			 ,'GYCK' as inv_ctrl_sys_id
       			 ,'最高人民法院涉案账户资金网络查控系统' as inv_ctrl_sys_name
       			 ,'控' as inv_ctrl_char
			 	 from ${iol_schema}.mpcs_a0ptkzcljg a4
			 	 inner join ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo b4
			 	 		on a4.bdhm = b4.bdhm
			 	 	 and b4.kzcs = '06'
			 	 	 and b4.start_dt<=to_date('${batch_date}','yyyymmdd')
			 	 	 and b4.end_dt>to_date('${batch_date}','yyyymmdd')
			 	 	 and a4.start_dt<=to_date('${batch_date}','yyyymmdd')
			 	 	 and a4.end_dt>to_date('${batch_date}','yyyymmdd')
			 	 where trim(a4.hostseqno) is not null --高院划扣流水号和日期
				union all
			 select hostnbr as transq
			 			 ,hostdate as frozdt
			 			 ,'10' as type_cd
			 			 ,(case when xtbz = 'GDJC' then 'GDJC' else 'GACD' end) as inv_ctrl_sys_id
      			 ,(case when xtbz = 'GDJC' then '广东省检察院查冻系统' else '广东省公安厅查冻系统' end) as inv_ctrl_sys_name
       			 ,'控' as inv_ctrl_char
			 	 from ${iol_schema}.mpcs_a77subacctzf a5
			 	where trim(hostnbr) is not null
			 		and a5.start_dt <= to_date('${batch_date}','yyyymmdd')
			 		and a5.end_dt > to_date('${batch_date}','yyyymmdd')) t3 ---司法止付流水号
			 		;

		
-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_froz_stop_pay_dtl_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_dep_froz_stop_pay_dtl where 0=1;

--第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_froz_stop_pay_dtl_ex(
	  etl_dt                        --数据日期      
	 ,lp_id                         --法人编号      
	 ,froz_stop_pay_dt              --冻结止付日期
   ,froz_stop_pay_timestamp       --冻结止付时间戳	 
	 ,froz_stop_pay_flow_num        --冻结止付流水号   
	 ,seq_num                       --顺序号       
	 ,tran_flow_num                 --交易流水号     
	 ,acct_id                       --账户编号      
	 ,sub_acct_id                   --子户编号  
	 ,dep_sub_acct_id	              --存款分户编号
	 ,old_sub_acct_id               --旧子户编号
	 ,cust_id                       --客户编号      
	 ,cust_name                     --客户名称      
	 ,cert_id                       --证明书编号     
	 ,proof_cate_cd                 --证明类别代码    
	 ,status_cd                     --状态代码      
	 ,chn_cd                        --渠道代码      
	 ,froz_stop_pay_bus_way_cd      --冻结止付业务方式代码
	 ,froz_stop_pay_cate_cd         --冻结止付类别代码  
	 ,operr_id                      --操作员编号 
   ,apv_teller_id                 --审批柜员编号
	 ,auth_teller_id                --授权柜员编号 
	 ,tran_org_id                   --交易机构编号    
	 ,appl_froz_amt                 --申请冻结金额    
	 ,surp_froz_amt                 --剩余冻结金额    
	 ,froz_end_dt                   --冻结截至日期    
	 ,froz_rs                       --冻结原因      
	 ,exec_org_name                 --执行机关名称    
	 ,exec_cert_cd_1                --执行证件代码1   
	 ,exec_id_1                     --执行编号1     
	 ,exec_cert_cd_2                --执行证件代码2   
	 ,exec_id_2                     --执行编号2     
	 ,exec_ps_name_1                --执行人名称1
	 ,exec_ps_name_2                --执行人名称2
	 ,jut_froz_stop_pay_flg         --司法冻结止付标志  
	 ,jut_froz_stop_pay_type_cd     --司法冻结止付类型代码
	 ,inv_ctrl_sys_id				        --查控系统编号
	 ,inv_ctrl_sys_name				      --查控系统名称
	 ,inv_ctrl_char				          --查控性质
   ,job_cd                        --任务代码
   ,etl_timestamp                 --etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')              --数据日期                                                                                                                                                        
    ,t1.lp_id                                           --法人编号     
		,t1.effect_dt                                       --冻结止付日期
		,t1.tran_tm                                         --冻结止付时间戳
		,nvl(trim(t1.ova_flow_num),'-')                     --冻结止付流水号         
		,t1.lmt_id                                          --顺序号                 
		,t1.tran_ref_no                                     --交易流水号             
		,nvl(trim(t4.cust_acct_num),'-')                    --账户编号               
		,nvl(trim(t4.sub_acct_num),'-')                     --子户编号   
    ,t1.acct_id                                         --存款分户编号
    ,t6.acct_seq_no_o		                                --旧子户编号
		,t1.cust_id                                         --客户编号               
		,t4.acct_name                                     --客户名称               
		,t1.froz_org_law_doc_num                           --证明书编号             
		,t1.proof_cate_cd                                  --证明类别代码           
		,t1.acct_lmt_status_cd                             --状态代码               
		,t5.chn_id                                         --渠道代码              
		,t1.tran_lmt_type_cd                               --冻结止付业务方式代码   
		,t1.sub_lmt_cate_cd                                --冻结止付类别代码       
		,t1.tran_teller_id                                 --操作员编号   	
		,t1.check_teller_id                                --审批柜员编号
	  ,t1.auth_teller_id                                 --授权柜员编号
		,t1.tran_org_id                                    --交易机构编号           
		,t1.begin_amt                                      --申请冻结金额           
		,t1.acct_lmt_amt                                   --剩余冻结金额           
		,t1.invalid_dt	                                   --失效日期           
		,t1.tran_memo_descb                                --冻结原因               
		,t1.froz_org_name                                  --执行机关名称           
		,t1.enforc_ps_1_cert_a_type_cd                     --执行证件代码1          
		,t1.enforc_ps_1_cert_a_no                          --执行编号1              
		,t1.enforc_ps_2_cert_a_type_cd                     --执行证件代码2          
		,t1.enforc_ps_2_cert_a_no                          --执行编号2              
		,t1.enforc_ps_1_name                               --执行人名称1            
		,t1.enforc_ps_2_name                               --执行人名称2            
		,case when trim(t2.type_cd) is null and trim(t3.type_cd) is null then '0'
          else '1'
          end as jut_froz_stop_pay_flg			--司法冻结止付标志																														
		,case when trim(t2.type_cd) is not null then t2.type_cd
          when trim(t3.type_cd) is not null then t3.type_cd 
          else '00'
          end as jut_froz_stop_pay_type_cd	--司法冻结止付类型代码																															 
		,case when trim(t2.inv_ctrl_sys_id) is not null then t2.inv_ctrl_sys_id
          when trim(t3.inv_ctrl_sys_id) is not null then t3.inv_ctrl_sys_id 
          else ''
          end as inv_ctrl_sys_id			--查控系统编号							
		,case when trim(t2.inv_ctrl_sys_name) is not null then t2.inv_ctrl_sys_name	
     		  when trim(t3.inv_ctrl_sys_name) is not null then t3.inv_ctrl_sys_name 	
      	  else '00'	
 		      end as inv_ctrl_sys_name			--查控系统名称									
		,case when trim(t2.inv_ctrl_char) is not null then t2.inv_ctrl_char	
      	  when trim(t3.inv_ctrl_char) is not null then t3.inv_ctrl_char 	
      	  else '00'	
		      end as inv_ctrl_char			--查控性质																															       		 			
      ,t1.job_cd        --任务代码
      ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')         --etl处理时间戳      
  from ${iml_schema}.agt_dep_acct_lmt_info_h t1  --存款账户限制明细
  left join ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_01 t2
    on t1.ova_flow_num = t2.frozsq
   and t1.effect_dt = to_date(t2.frozdt,'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_02 t3
	on t1.ova_flow_num = t3.transq
   and t1.effect_dt = to_date(t3.frozdt,'yyyymmdd')		
  left join ${iml_schema}.agt_dep_acct_info_h t4 --存款账户信息历史 	
    on t1.acct_id = t4.acct_id
   and t4.job_cd = 'ncbsf1'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join (select tc.chn_id,
                    tc.ova_flow_num,
  				  tc.chn_tran_dt,
  				  tc.tran_ref_no,
                    row_number() over(partition by tc.ova_flow_num,tc.chn_tran_dt,tc.tran_ref_no order by tran_tm desc) rn
  	              from ${iml_schema}.evt_dep_tran_flow_ctrl_flow tc
                    where tc.job_cd = 'ncbsi1'		  
             ) t5   
  	on t1.ova_flow_num = t5.ova_flow_num 
     and t1.tran_dt = t5.chn_tran_dt 
     and t1.tran_ref_no = t5.tran_ref_no                    
     and t5.rn = 1
  left join ${iol_schema}.ncbs_new_old_seq_no t6	 
    on t4.cust_acct_num = t6.base_acct_no 
   and t4.sub_acct_num = t6.acct_seq_no
 where /*t1.effect_dt=to_date('${batch_date}','yyyymmdd')
   and*/ t1.job_cd = 'ncbsf1'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
 ;
commit;
		
-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_froz_stop_pay_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_froz_stop_pay_dtl_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_froz_stop_pay_dtl_ex purge;
--drop table ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_01 purge;
--drop table ${icl_schema}.tmp_cmm_dep_froz_stop_pay_dtl_02 purge;
-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_dep_froz_stop_pay_dtl', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);