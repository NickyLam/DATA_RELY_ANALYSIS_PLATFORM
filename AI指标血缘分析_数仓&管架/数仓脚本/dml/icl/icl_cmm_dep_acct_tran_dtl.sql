/*
Purpose:    共性加工层-存款账户交易明细:包括所有行内存款账户的金融交易明细，数据来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_dep_acct_tran_dtl
Createdate: 20200424
Logs:	     20220314 翟若平	 1、调整取数源，由旧核心系统调整到新核心系统取数
                             2、增加字段【交易对手账户开户行代码、真实交易对手账户编号、
								             真实交易对手账户名称、真实交易对手金融机构代码、真实交易对手金融机构名称】"
           20220316 翟若平	1、增加字段【代理人客户编号】
           20220402 翟若平 1、调整字段【交易标识号、记帐柜员编号、代理类型代码】的取数口径
           20220429 翟若平 1、调整字段【摘要代码、交易代码、回单编号、回单描述信息、代理人发证机关所在地】的取数口径；
                            2、新增字段【冲正交易日期、冲正交易流水号、冲正交易码、现金项目代码、外围系统编码】
           20220531 李森辉 1、调整字段【经办人证件类型代码、经办人证件号码、经办人名称】的取数口径；
           20220606 温旺清 1、新增字段【旧存款分户编号、旧子户编号】
           20220708 温旺清 1、调整字段【客户类型】的加工口径
           20220724 翟若平 调整字段【小额免密标志】的加工口径
           20220812 翟若平 调整字段【客户端IP地址、客户终端MAC地址】的加工口径
           20220818 黄俊杰 代理人国籍代码 置默认值
           20220818 李森辉 调整【抹账标志、冲正标志、现转标志】加工口径
		       20220823 温旺清 1、新增字段【交易对手分户编号】
                           2、调整字段【抹账标志、冲正标志、现转标志、提前支取标志】的加工口径
		       20220824 温旺清 1、调整字段名称：旧存款分户编号OLD_ACCT_ID -》 原分户编号INIT_DEP_SUB_ACCT_ID、旧子户编号OLD_SUB_ACCT_ID -》 原子户编号INIT_SUB_ACCT_ID
                        2、调整字段【代理人名称、代理人证件类型代码、代理人证件号码、代理人性别代码、代理人国籍代码、代理人证件开始日、代理人证件到期日、代理人联系电话、代理原因、摘要代码描述】的加工口径
           20221103 曹永茂 1、【真实交易对手账户名称】应急截取100长度
           20221205 曹永茂 根据核心在BUG_043494反馈的口径，调整【交易余额】取数口径, t1.actl_bal * -1 -> abs(t1.actl_bal)
           20230104 陈伟峰 调整字段【现转标志】的加工口径
           20230105 陈伟峰 调整NCBS_RB_COMMISSION_REGISTER表关联条件，仅用REFERENCE关联
           20230106 翟若平 调整字段【交易余额】的加工口径
           20230109 翟若平 调整字段【渠道代码】的加工口径
           20230110 陈伟峰 新增字段【业务产品编号】
           20230214 温旺清 新增字段【原交易时间戳】
           20230216 翟若平 调整字段【真实交易对手账户名称】的加工口径
           20230228 陈伟峰 调整字段【现转标志】的加工口径
           20230321 陈伟峰 调整字段【现转标志】的加工口径,增加'TB01','TB05','TB07','TB13','TB15','TB18','TB19','TB21','TB22'
           20230328 陈伟峰 调整字段【记账标志】 ，默认给'1'
           20230821 徐子豪 新增字段【跨境交易标志】,调整【交易对手账户名称】加工逻辑，用OTH_ACCT_DESC补充，核心确认针对部分业务（例如活期转开新账户）只维护OTH_ACCT_DESC
           20230922 徐子豪 优化变更主表TRAN_DT取值为ETL_DT分区字段,网上银行流水信息关联条件在临时表中取值。
           20231206 徐子豪 数据治理组排查,发现之前跨境标志加工的部分语句有误,取数来源表ISBS_DBD调整为ISBS_DBB。
           20231212 陈伟峰 调整临时表tmp_cmm_dep_acct_tran_dtl_02取数逻辑，增加技术日期字段
           20231228 陈伟峰 调整【跨境标识】加工逻辑
                           调整【现转标志】加工逻辑，增加数字人民币码值DC17、DC18、DC19、DC20、DC21、DC22、DC23、DC24
           20240130 陈伟峰 取数来源表ISBS_DBD调整为ISBS_DBB
           20240131 陈伟峰 调整【tmp_cmm_dep_acct_tran_dtl_02】加工逻辑，当MAC地址不为空时也取
           20240508 陈伟峰 调整IP\MAC地址取数逻辑，新增evt_ponl_bk_oper_mgmt_flow个人网银运营管理流水取数
           20240524 陈伟峰 调整跨境标志取数口径
           20240607 陈伟峰 调整evt_onl_bank_tran_flow、evt_bank_pc_edit_tran_flow 增量条件字段
           20240614 陈伟峰 调整银联部分跨境交易标志判断表，从mpcs_a50ubcardjourhis调整成evt_atmp_unionpay_tran_flow
           20240702 陈伟峰 优化IP\MAC地址取数逻辑
           20241107 陈伟峰 调整跨境标志逻辑中relflg='R' -> relflg in ('B','R')
                           新增银联部分交易IP\MAC地址取值逻辑
           20241118 陈伟峰 添加IP\MAC特殊处理逻辑，针对上游系统跟核心日切不一致导致的数据缺失问题做特别处理
           20241118 谢  宁 调整【摘要代码描述】逻辑
           20241122 陈伟峰 调整【跨境标志】逻辑，增加退税场景（申报表无记录的部分）
           20241219 陈伟峰 调整代理人部分逻辑，去除业务流水号关联，仅用全局流水号去重取一条
           20250124 陈伟峰 调整国结跨境标志加工逻辑，去掉'交易对手名称里含“（JN）”的交易维护为非跨境'的规则
           20250414 陈伟峰 调整IP地址取数逻辑，过滤'%dcspibsas%' 无效IP
           20250425 陈伟峰 调整IP\MAC地址部分逻辑，增加补充核心自动转存流水IP\MAC
           20250623 陈伟峰 调整IP\MAC地址部分逻辑，增加企业网银代发在中台系统全局流水号映射逻辑
           20251107 陈伟峰 调整【跨境标识】加工逻辑，增加中台跨境支付通数据
		   20260407 周文龙 修改临时表的创建规则
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_acct_tran_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_dep_acct_tran_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_01 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_02 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_03 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_04 purge;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_05 purge;
-- 1.3 insert data to tmp table
-- 获取账户联系人信息（经办人证件类型代码、经办人证件号码、经办人名称等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_01
nologging
compress ${option_switch} for query high
as
select t1.acct_id
       ,t1.cotas_cert_type_cd
       ,t1.cotas_cert_no
       ,t1.cotas_name
       ,t1.cotas_tel_num_one
       ,t1.tran_tm
       ,t1.cotas_type_id
       ,t1.data_valid_flg
       ,row_number() over(partition by t1.acct_id order by t1.cotas_tel_num_one desc, t1.tran_tm desc) as rn
  from ${iml_schema}.agt_dep_acct_cotas_info_h t1
 where t1.data_valid_flg = '1'
   and t1.cotas_type_id = 'FC'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ncbsf1'
;



-- 1.4 insert data to tmp table
-- 创建IP\MAC临时表，使用上游近一个月交易流水用于获取数据
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_02
nologging
compress ${option_switch} for query high
as
select t1.sorc_sys_flow_num
       ,t1.core_tran_dt
       ,t1.tran_acct_num
       ,t1.cust_ip_num
       ,t1.cust_termn_mac_addr
       ,row_number() over(partition by t1.sorc_sys_flow_num order by t1.core_tran_dt) rn
 from (select sorc_sys_flow_num,
       			  core_tran_dt,
       			  tran_acct_num,
       			  cust_ip_num,
       			  cust_termn_mac_addr
         from ${iml_schema}.evt_onl_bank_tran_flow
        where job_cd = 'osbsf1'
          and tran_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and trim(sorc_sys_flow_num) is not null
          and cust_ip_num not like '%dcspibsas%'
        union all
       select sorc_sys_flow_num,
       			  core_tran_dt,
       			  tran_acct_num,
       			  cust_ip_num,
       			  cust_termn_mac_addr
         from ${iml_schema}.evt_os_priv_serv_bus_flow
        where tran_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(sorc_sys_flow_num) is not null
          and cust_ip_num not like '%dcspibsas%'
        union all
       select sorc_sys_flow_num,
       			  core_tran_dt,
       			  tran_acct_num,
       			  cust_ip_num,
       			  cust_termn_mac_addr
         from ${iml_schema}.evt_os_invest_finc_bus_flow
        where tran_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(sorc_sys_flow_num) is not null
          and cust_ip_num not like '%dcspibsas%'
        union all
       select
              sorc_sys_flow_id as sorc_sys_flow_num,
              core_tran_dt as core_tran_dt,
              tran_acct_num as tran_acct_num,
              cust_ip as cust_ip_num,
              cust_termn_mac_addr as cust_termn_mac_addr
         from ${iml_schema}.evt_bank_pc_edit_tran_flow
        where job_cd = 'tbpsf1' -- 20230315 调整关联条件，去掉日期条件，m层是每天全量切片
          and tran_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and trim(sorc_sys_flow_id) is not null
          and cust_ip not like '%dcspibsas%'
        union all
       select ova_flow_num as sorc_sys_flow_num,
              core_tran_dt as core_tran_dt,
              tran_acct_num as tran_acct_num,
              client_ip as cust_ip_num,
              client_mac as cust_termn_mac_addr
         from ${iml_schema}.evt_priv_onl_bank_tran_flow t
        where tran_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(ova_flow_num) is not null
          and client_ip not like '%dcspibsas%'
        union all
       select sorc_sys_flow_num as sorc_sys_flow_num,
              tran_tm as core_tran_dt,
              acct_id as tran_acct_num,
              cust_ip as cust_ip_num,
              cust_termn_mac_addr as cust_termn_mac_addr
         from ${iml_schema}.evt_ponl_bk_oper_mgmt_flow t
        where tran_tm >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and tran_tm <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(sorc_sys_flow_num) is not null
          and cust_ip not like '%dcspibsas%'
        union all
       select ova_flow_num as sorc_sys_flow_num,
              corp_work_dt as core_tran_dt,
              '' as tran_acct_num,
              output_ip_addr as cust_ip_num,
              output_mac_val as cust_termn_mac_addr
         from ${iml_schema}.evt_bcdl_tran_dtl t
        where corp_work_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and corp_work_dt <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'mpcsi1'
          and trim(ova_flow_num) is not null
          and output_ip_addr not like '%dcspibsas%'
        union all
       select
              t2.ova_flow_num2 as sorc_sys_flow_num,
              t1.core_tran_dt as core_tran_dt,
              t1.tran_acct_num as tran_acct_num,
              t1.cust_ip as cust_ip_num,
              t1.cust_termn_mac_addr as cust_termn_mac_addr
         from ${iml_schema}.evt_bank_pc_edit_tran_flow t1  --evt_bank_pc_edit_tran_flow
        inner join (select distinct t1.ova_flow_num,t2.ova_flow_num as ova_flow_num2 
                         from (select distinct ova_flow_num,core_tran_flow_num,core_tran_dt 
                                  from ${iml_schema}.evt_conl_bk_payoff_dtl
                                  where core_tran_dt  >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
                                    and core_tran_dt <= to_date('${batch_date}','yyyymmdd')
			                        and etl_dt  >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
                                    and etl_dt <= to_date('${batch_date}','yyyymmdd')
                                    and job_cd ='mpcsi1')t1
                         left join (select distinct tran_ref_no,tran_dt,ova_flow_num
                                        from ${iml_schema}.evt_dep_fin_tran_flow t1
                                       where etl_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
                                         and etl_dt<= to_date('${batch_date}','yyyymmdd')
                                         and tran_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
                                         and tran_dt<= to_date('${batch_date}','yyyymmdd')
                                         and job_cd ='ncbsi1'
                                         and exists (select 1 from ${iml_schema}.evt_conl_bk_payoff_dtl t3 
                                                        where t3.core_tran_flow_num=t1.tran_ref_no 
                                                           and t3.etl_dt  >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
                                                           and t3.etl_dt <= to_date('${batch_date}','yyyymmdd'))
                                     ) t2
                           on t1.core_tran_flow_num=t2.tran_ref_no
                          and t1.core_tran_dt=t2.tran_dt
                          ) t2    --企业网银流水流经中台再进核心时，中台会重新生成全局流水号给到核心，导致企业网银流水跟核心关联不上，需要做一层映射
           on t1.sorc_sys_flow_id=t2.ova_flow_num
        where t1.tran_dt >= add_months(to_date('${batch_date}','yyyymmdd'), -1)
          and t1.tran_dt <= to_date('${batch_date}','yyyymmdd')
          and trim(t1.sorc_sys_flow_id) is not null
          and job_cd = 'tbpsf1'
       ) t1 where trim(t1.cust_ip_num) is not null or trim(t1.cust_termn_mac_addr) is not null
;
commit;

-- 1.5 insert data to tmp table
-- 获取区分跨境交易口径(含涉外收入申报单、境外汇款申请书、对外承兑通知书等)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_03
nologging
compress ${option_switch} for query high
as
select * from (
   --国结
   with tmp1 as (select source_id,qjls,ywls,tran_type from (
 select 'ISBS' as source_id,trn.qjls as qjls,wfe.itfinr as ywls,
         case when trim(gl.tran_type) is not null then trim(gl.tran_type)
              when wfe.srv ='SHA'  then 'FX09'
              when wfe.srv ='JHA'  then 'FX04'
               end as tran_type
   from ${iol_schema}.isbs_dba dba
  inner join  ${iol_schema}.isbs_trn trn
     on (trim(trn.ownref)=trim(dba.buscode))
    and trim(trn.qjls) is not null and trn.relflg in ('B','R')
    and trn.start_dt <= to_date('${batch_date}','yyyymmdd') and trn.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_gl059660 gl
     on gl.trninr=trn.inr
  inner join ${iol_schema}.isbs_wfs wfs
     on wfs.objinr=trn.inr and wfs.objtyp='TRN'
    and wfs.start_dt <=to_date('${batch_date}','yyyymmdd') and wfs.end_dt >to_date('${batch_date}','yyyymmdd')
  inner join ${iol_schema}.isbs_wfe wfe
     on wfe.wfsinr=wfs.inr
    and wfe.srv IN('SHA','ACT','JHA')
    and wfe.start_dt <=to_date('${batch_date}','yyyymmdd') and wfe.end_dt >to_date('${batch_date}','yyyymmdd')
  where dba.start_dt <=to_date('${batch_date}','yyyymmdd') and dba.end_dt >to_date('${batch_date}','yyyymmdd')
--    and dba.oppuser not like '%(JN)%'   --剔除JN境内交易
  union all
 select 'ISBS' as source_id,trn.qjls as qjls,wfe.itfinr as ywls,
         case when trim(gl.tran_type) is not null then trim(gl.tran_type)
              when wfe.srv ='SHA'  then 'FX09'
              when wfe.srv ='JHA'  then 'FX04'
               end as tran_type
   from ${iol_schema}.isbs_dbb dbb
  inner join  ${iol_schema}.isbs_trn trn
     on (trim(trn.ownref)=trim(dbb.buscode))
    and trim(trn.qjls) is not null and trn.relflg in ('B','R')
    and trn.start_dt <= to_date('${batch_date}','yyyymmdd') and trn.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_gl059660 gl
     on gl.trninr=trn.inr
  inner join ${iol_schema}.isbs_wfs wfs
     on wfs.objinr=trn.inr and wfs.objtyp='TRN'
    and wfs.start_dt <=to_date('${batch_date}','yyyymmdd') and wfs.end_dt >to_date('${batch_date}','yyyymmdd')
  inner join ${iol_schema}.isbs_wfe wfe
     on wfe.wfsinr=wfs.inr
    and wfe.srv IN('SHA','ACT','JHA')
    and wfe.start_dt <=to_date('${batch_date}','yyyymmdd') and wfe.end_dt >to_date('${batch_date}','yyyymmdd')
  where dbb.start_dt <=to_date('${batch_date}','yyyymmdd') and dbb.end_dt >to_date('${batch_date}','yyyymmdd')
--    and dbb.oppuser not like '%(JN)%'   --剔除JN境内交易
  union all
 select  'ISBS' as source_id,trn.qjls as qjls,wfe.itfinr as ywls,
          case when trim(gl.tran_type) is not null then trim(gl.tran_type)
               when wfe.srv ='SHA'  then 'FX09'
               when wfe.srv ='JHA'  then 'FX04'
               end as tran_type
   from ${iol_schema}.isbs_dbc dbc
  inner join  ${iol_schema}.isbs_trn trn
     on (trim(trn.ownref)=trim(dbc.buscode))
    and trim(trn.qjls) is not null and trn.relflg in ('B','R')
    and trn.start_dt <= to_date('${batch_date}','yyyymmdd') and trn.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_gl059660 gl
     on gl.trninr=trn.inr
  inner join ${iol_schema}.isbs_wfs wfs
     on wfs.objinr=trn.inr and wfs.objtyp='TRN'
    and wfs.start_dt <=to_date('${batch_date}','yyyymmdd') and wfs.end_dt >to_date('${batch_date}','yyyymmdd')
  inner join ${iol_schema}.isbs_wfe wfe
     on wfe.wfsinr=wfs.inr
    and wfe.srv IN('SHA','ACT','JHA')
    and wfe.start_dt <=to_date('${batch_date}','yyyymmdd') and wfe.end_dt >to_date('${batch_date}','yyyymmdd')
  where dbc.start_dt <=to_date('${batch_date}','yyyymmdd') and dbc.end_dt >to_date('${batch_date}','yyyymmdd')
--    and dbc.oppuser not like '%(JN)%'   --剔除JN境内交易
  union all
--借方交易场景对手机构国家
 select 'ISBS' as source_id,t.qjls as qjls,e.itfinr as ywls
        ,case when trim(gl.tran_type) is not null then trim(gl.tran_type)
              when e.srv ='SHA'  then 'FX09'
              when e.srv ='JHA'  then 'FX04'
              end as tran_type
   from ${iol_schema}.isbs_trn t
   left join ${iol_schema}.isbs_oppnet o
     on t.inr=o.trninr
    and o.start_dt <=to_date('${batch_date}','yyyymmdd')
    and o.end_dt >to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_gl059660 gl
     on t.inr=gl.trninr
   left join ${iol_schema}.isbs_wfs s
     on s.objtyp='TRN'
    and s.objinr=t.inr
    and s.start_dt <=to_date('${batch_date}','yyyymmdd')
    and s.end_dt >to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_wfe e
     on e.wfsinr=s.inr
    and e.start_dt <=to_date('${batch_date}','yyyymmdd')
    and e.end_dt >to_date('${batch_date}','yyyymmdd')
  where e.srv in('SHA','ACT','JHA')
    and t.relflg in ('R','B')
    and o.tran_type='D'
    and t.inifrm in('CPTBCK','TRTOPN','CPTOPN','TRTCOL','BRTSET','GITSET','BCTSET')
    and trim(o.cntpty_fin_inst_brac_cd) is not null
    and regexp_like(upper(substr(o.cntpty_fin_inst_brac_cd,5,2)),'^[A-Z]')
    and substr(o.cntpty_fin_inst_brac_cd,5,2)<>'CN'
    and t.start_dt <=to_date('${batch_date}','yyyymmdd')
    and t.end_dt >to_date('${batch_date}','yyyymmdd')
  union all
    --贷方交易场景对手机构国家
 select 'ISBS' as source_id,t.qjls as qjls,e.itfinr as ywls
        ,case when trim(gl.tran_type) is not null then trim(gl.tran_type)
              when E.srv ='SHA'  then 'FX09'
              when E.srv ='JHA'  then 'FX04'
               end as tran_type
   from ${iol_schema}.isbs_trn t
   left join ${iol_schema}.isbs_oppnet o
     on t.inr=o.trninr
    and o.start_dt <=to_date('${batch_date}','yyyymmdd')
    and o.end_dt >to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_gl059660 gl
     on t.inr=gl.trninr
   left join ${iol_schema}.isbs_wfs s
     on s.objtyp='TRN'
    and s.objinr=t.inr
    and s.start_dt <=to_date('${batch_date}','yyyymmdd')
    and s.end_dt >to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_wfe e
     on e.wfsinr=s.inr
    and e.start_dt <=to_date('${batch_date}','yyyymmdd')
    and e.end_dt >to_date('${batch_date}','yyyymmdd')
  where e.srv in('SHA','ACT','JHA')
    and t.relflg in ('R','B')
    and o.tran_type='C'
    and t.inifrm in('CPTADV','BETSET','CPTREP','BOTSET','GETSET','GITSET','BCTSET')
    and trim(o.cntpty_fin_inst_brac_cd) is not null
    and regexp_like(upper(substr(o.cntpty_fin_inst_brac_cd,5,2)),'^[A-Z]')
    and substr(o.cntpty_fin_inst_brac_cd,5,2)<>'CN'
    and t.start_dt <=to_date('${batch_date}','yyyymmdd')
    and t.end_dt >to_date('${batch_date}','yyyymmdd')
 )
 group by source_id,qjls,ywls,tran_type
   ),
   --银联
   tmp2 as (select source_id,qjls,ywls,tran_type from (
            select 'MPCS' as source_id,ova_flow_num as qjls,tran_flow_num as ywls,b.transtp as tran_type
              from ${iml_schema}.evt_atmp_unionpay_tran_flow a
              left join(select trncd,transtp
                          from ${iol_schema}.mpcs_a51ttrncdmap
                         where trim(transtp) is not null
                           and start_dt <=to_date('${batch_date}','yyyymmdd')
                           and end_dt >to_date('${batch_date}','yyyymmdd')
                         group by trncd,transtp) b
                on a.intnal_tran_cd=b.trncd
             where a.send_org_id in('00010344','00010446') or a.recv_org_id in ('00010344','00010446') --香港、澳门清算通道，包括发送方与受理方
               and a.job_cd ='mpcsi1'
           ) group by source_id,qjls,ywls,tran_type
           )
   select t1.channel_seq_no,t1.tran_type,t1.bus_seq_no,t1.tran_date,t1.seq_no,'1' as cross_bor_tran_flg
     from  ${iol_schema}.ncbs_rb_tran_hist t1
    inner join tmp1 t2
       on t1.channel_seq_no =t2.qjls
      and t1.tran_type=t2.tran_type
      and t1.sub_seq_no=t2.ywls
    where t1.tran_type in ('FX04','FX09','4686','4689','GJ01','GJ03')
      and t1.tran_date=to_date('${batch_date}','yyyymmdd')
    union all
   select t1.channel_seq_no,t1.tran_type,t1.bus_seq_no,t1.tran_date,t1.seq_no,'1'  as cross_bor_tran_flg
     from  ${iol_schema}.ncbs_rb_tran_hist t1
    inner join tmp2 t2
       on t1.channel_seq_no =t2.qjls
      and t1.tran_type=t2.tran_type
      and t1.sub_seq_no=t2.ywls
    where t1.tran_type in ('YL09','UC13','UC17','UC19','UC09','UC07','UC42','UC43','UC45','UC01','UC34','UC35','YL11','UC11','UC15') --银联跨境交易涉及的交易类型
      and t1.tran_date=to_date('${batch_date}','yyyymmdd')
    union all
   select t1.channel_seq_no,t1.tran_type,t1.bus_seq_no,t1.tran_date,t1.seq_no,'1'  as cross_bor_tran_flg
     from  ${iol_schema}.ncbs_rb_tran_hist t1
    inner join tmp2 t2
       on t1.channel_seq_no =t2.qjls
      and t1.sub_seq_no=t2.ywls
    where t1.tran_type in ('YL10','UC14','UC18','UC20','UC96','UC08','UC98','UC44','UC46','UC02','UC95','UC36','YL12','UC12','UC16') --银联跨境交易对应的冲正交易，该部分交易类型由核心根据正常交易与冲正交易类型的映射提供。由于冲正交易银联交易表无交易类型，只通过流水号与核心交易关联
      and t1.tran_date=to_date('${batch_date}','yyyymmdd'))
;

-- 1.6 insert data to tmp table
-- PART1  根据核心自动转存签约和转存流水，补充回自动转存流水的IP\MAC地址
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_04
nologging
compress ${option_switch} for query high
as
select t.acct_id                                                 --账号
            ,a.src_agt_id                                           --签约协议
            ,fti.seq_no                                              --签约时全局流水号
            ,fti.etl_dt                                                --日期
           ,t3.ova_flow_num       as sorc_sys_flow_num --核心全局流水号,转存时的流水号
           ,t.tran_ref_no              as tran_flow_num
           ,t.tran_dt                    as tran_dt
           ,t3.tran_flow_num      as acct_bill_flow_num
  from ${iml_schema}.evt_reg_tran_flow t  --定期交易流水
  inner join ${iml_schema}.agt_dep_acct_info_h a   --通过账户关联回签约协议号
       on a.acct_id = t.acct_id
     and a.job_cd ='ncbsf1'
     and a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
   inner join ${iml_schema}.agt_finc_sign_agt_h raf   --通过签约协议号关联回签约流水
       on raf.dep_agt_id = a.src_agt_id
     and raf.job_cd ='ncbsf1'
     and raf.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and raf.end_dt > to_date('${batch_date}', 'yyyymmdd')
   inner join ${iol_schema}.ncbs_rb_fw_tran_info fti   --通过签约流水获取签约时全局流水和签约日期
       on fti.reference = raf.sign_flow_id
   inner join ${iml_schema}.evt_dep_fin_tran_flow t3 --ens_rb.rb_tran_hist
       on t3.tran_ref_no = t.tran_ref_no
     and t3.tran_dt = t.tran_dt
     and t3.debit_crdt_flg = 'C' --新增
     and t3.job_cd ='ncbsi1'
     and t3.tran_dt = to_date('${batch_date}', 'yyyymmdd')
     and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 where t.redt_type_cd = 'A'
     and t.tran_dt = to_date('${batch_date}', 'yyyymmdd')
     and t.job_cd ='ncbsi1'
 -- and t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- PART2  根据核心自动转存签约和转存流水，补充回自动转存流水的IP\MAC地址
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_05
nologging
compress ${option_switch} for query high
as
   select t2.sorc_sys_flow_num
              ,t2.tran_flow_num
              ,t2.tran_dt
              ,t2.acct_bill_flow_num
             ,t1.client_ip  as cust_ip_num
             ,t1.client_mac  as cust_termn_mac_addr
            ,row_number() over(partition by t2.tran_flow_num,t2.tran_dt,t2.acct_bill_flow_num order by t2.tran_flow_num,t2.tran_dt,t2.acct_bill_flow_num) as rn
from ${iml_schema}.evt_priv_onl_bank_tran_flow t1 --opsprd.ops_trade_flow t2
inner join ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_04 t2    --通过签约流水和签约日期关联获取IP\MAC地址
       on t1.ova_flow_num = t2.seq_no
     and t1.etl_dt =t2.etl_dt
     and t1.job_cd ='osbsi1'
where trim(t1.ova_flow_num) is not null
;

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_acct_tran_dtl_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_dep_acct_tran_dtl where 0=1;

--第一组（共一组）新核心存款金融交易流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_acct_tran_dtl_ex(
    etl_dt                         -- 数据日期
    ,lp_id                         -- 法人编号
    ,tran_flow_num                 -- 交易流水号
    ,tran_dt                       -- 交易日期
    ,tran_timestamp                -- 交易时间戳
    ,init_tran_timestamp           -- 原交易时间戳
    ,acct_bill_flow_num            -- 账单流水号
    ,ova_flow_num                  -- 全局流水号
    ,tran_flg_num                  -- 交易标识号
    ,acct_org_id                   -- 账户机构编号
    ,dep_sub_acct_id               -- 存款分户编号
    ,cust_acct_id                  -- 客户账户编号
    ,sub_acct_id                   -- 子户编号
	  ,init_dep_sub_acct_id          -- 原分户编号
	  ,init_sub_acct_id              -- 原子户编号
    ,cust_id                       -- 客户编号
    ,cust_name                     -- 客户名称
    ,cust_type_cd                  -- 客户类型代码
    ,bus_prod_id                   -- 业务产品编号
    ,tran_kind_cd                  -- 交易类型代码
    ,elec_tran_kind_cd             -- 电子交易种类代码
    ,tran_status_cd                -- 交易状态代码
    ,debit_crdt_dir_cd             -- 借贷方向代码
	  ,cash_proj_cd                  -- 现金项目代码
    ,tran_vouch_id                 -- 交易凭证编号
    ,vouch_kind_cd                 -- 凭证种类代码
    ,memo_cd                       -- 摘要代码
    ,memo_cd_descb                 -- 摘要代码描述
    ,chn_cd                        -- 渠道代码
	  ,cntpty_inter_acct_id          -- 交易对手分户编号
    ,cntpty_acct_id                -- 交易对手账户编号
    ,cntpty_sub_acct_id            -- 交易对手子账户编号
    ,cntpty_acct_name              -- 交易对手账户名称
    ,cntpty_open_bank_id           -- 交易对手账户开户行编号
    ,cntpty_acct_open_bank_cd      -- 交易对手账户开户行代码
    ,cntpty_open_bank_name         -- 交易对手账户开户行名称
    ,real_cntpty_acct_id           -- 真实交易对手账户编号
    ,real_cntpty_acct_name         -- 真实交易对手账户名称
    ,real_cntpty_fin_inst_cd       -- 真实交易对手金融机构代码
    ,real_cntpty_fin_inst_name     -- 真实交易对手金融机构名称
    ,tran_org_id                   -- 交易机构编号
    ,tran_curr_cd                  -- 交易币种代码
    ,tran_amt                      -- 交易金额
    ,tran_bal                      -- 交易余额
    ,tran_teller_id                -- 交易柜员编号
    ,check_teller_id               -- 复核柜员编号
    ,auth_teller_id                -- 授权柜员编号
    ,entry_teller_id               -- 记帐柜员编号
    ,erase_acct_flg                -- 抹账标志
    ,revs_flg                      -- 冲正标志
    ,cash_trans_flg                -- 现转标志
    ,unexp_draw_flg                -- 提前支取标志
    ,beps_unpasew_flg              -- 小额免密标志
    ,bal_chk_flg                   -- 勾对标志
    ,cross_bor_tran_flg            -- 跨境交易标志
    ,termn_id                      -- 终端编号
    ,tran_cd                       -- 交易代码
    ,tran_descb                    -- 交易描述
    ,rece_type_cd                  -- 回单类型代码
    ,tran_name                     -- 交易名称
	  ,prpery_sys_code               -- 外围系统编码
    ,rece_id                       -- 回单编号
    ,rece_descb_info               -- 回单描述信息
    ,agent_cust_id                 -- 代理人客户编号
    ,agent_name                    -- 代理人名称
    ,agent_cert_type_cd            -- 代理人证件类型代码
    ,agent_cert_no                 -- 代理人证件号码
    ,agent_gender_cd               -- 代理人性别代码
    ,agent_nation_cd               -- 代理人国籍代码
    ,agent_cert_start_dt           -- 代理人证件开始日
    ,agent_cert_exp_dt             -- 代理人证件到期日
    ,agent_phone                   -- 代理人联系电话
    ,agent_licen_issue_autho_site  -- 代理人发证机关所在地
    ,agent_rs                      -- 代理原因
    ,agent_type_cd                 -- 代理类型代码
    ,operr_cert_type_cd            -- 经办人证件类型代码
    ,operr_cert_no                 -- 经办人证件号码
    ,operr_name                    -- 经办人名称
    ,client_ip_addr                -- 客户端ip地址
    ,cust_termn_mac_addr           -- 客户终端mac地址
    ,entry_flg                     -- 记账标志
	  ,revs_tran_dt                  -- 冲正交易日期
	  ,revs_tran_flow_num            -- 冲正交易流水号
 	  ,revs_tran_code                -- 冲正交易码
	  ,job_cd                        -- 任务代码
    ,etl_timestamp                 -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')           -- 数据日期
      ,t1.lp_id                                      -- 法人编号
      ,t1.tran_ref_no                                -- 交易流水号
      ,t1.tran_dt                                    -- 交易日期
      ,t1.tran_tm                                    -- 交易时间戳
      ,t1.init_tran_tm                               -- 原交易时间戳
      ,t1.tran_flow_num                              -- 账单流水号
      ,t1.ova_flow_num                               -- 全局流水号
      ,t1.core_flow_num                              -- 交易标识号
      ,t1.open_acct_org_id                           -- 账户机构编号
      ,t1.acct_id                                    -- 存款分户编号
      ,t1.cust_acct_num                              -- 客户账户编号
      ,t1.sub_acct_num                               -- 子户编号
      ,t9.acct_id                                    -- 原分户编号
      ,t9.acct_seq_no_o                              -- 原子户编号
      ,t1.cust_id                                    -- 客户编号
      ,t1.cust_name                                  -- 客户名称
      ,nvl(trim(t27.cust_type_cd), '-')              -- 客户类型代码
      ,t1.bus_prod_id                                -- 业务产品编号
      ,t1.tran_cd                                    -- 交易类型代码
      ,t1.evt_cate_id                                -- 电子交易种类代码
      ,t1.bus_proc_status_cd                         -- 交易状态代码
      ,t1.debit_crdt_flg                             -- 借贷方向代码
      ,t1.cash_proj_cd                               -- 现金项目代码
      ,t1.vouch_no                                   -- 交易凭证编号
      ,t1.vouch_type_cd                              -- 凭证种类代码
      ,t1.memo_code                                  -- 摘要代码
      ,nvl(trim(t15.memo_code_descb),t1.tran_memo_descb)  -- 摘要代码描述
      ,nvl(trim(t1.src_chn_id), t1.chn_id)           -- 渠道代码
	    ,t1.cntpty_acct_id                             -- 交易对手分户编号
      ,t1.cntpty_cust_acct_num                       -- 交易对手账户编号
      ,t1.cntpty_sub_acct_num                        -- 交易对手子账户编号
      ,nvl(t1.cntpty_name,t1.cntpty_acct_name)       -- 交易对手账户名称
      ,t1.cntpty_open_acct_org_id                    -- 交易对手账户开户行编号
      ,t1.cntpty_unionpay_num                        -- 交易对手账户开户行代码
      ,t1.cntpty_bank_name                           -- 交易对手账户开户行名称
      ,t1.real_cntpty_acct_id                        -- 真实交易对手账户编号
      ,nvl(trim(t1.real_cntpty_name), t1.cntpty_acct_name) as real_cntpty_acct_name  -- 真实交易对手账户名称
      ,t1.real_cntpty_fin_inst_id                    -- 真实交易对手金融机构代码
      ,t1.real_cntpty_fin_inst_name                  -- 真实交易对手金融机构名称
      ,t1.tran_org_id                                -- 交易机构编号
      ,t1.tran_curr_cd                               -- 交易币种代码
      ,t1.tran_amt                                   -- 交易金额
      ,decode(t17.acct_bal_dir_cd, 'C', -1, 'D', 1, -1) * t1.actl_bal as tran_bal  -- 交易余额
      ,t1.tran_teller_id                             -- 交易柜员编号
      ,t1.check_teller_id                            -- 复核柜员编号
      ,t1.auth_teller_id                             -- 授权柜员编号
      ,t1.tran_teller_id                             -- 记帐柜员编号
      ,t1.revs_flg                                   -- 抹账标志
      ,t1.revs_flg                                   -- 冲正标志
      ,case when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and t1.tran_cd like 'C%' then '1' --现金
            when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and t1.tran_cd like 'T%' then '0' --转账
            when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and substr(t1.tran_cd, 0, 1) not in ('C', 'T') and t13.trandt is not null then '1' --有现金记账(账单)
            when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and substr(t1.tran_cd, 0, 1) not in ('C', 'T') and t13.trantp is not null and t13.trandt is null then  '0' --无现金记账(账单)
            when t1.tran_cd in ('UC01','UC02','UC34','UC35','UC36','UC95','TB01','TB05','TB07','TB13','TB15','TB18','TB19','TB21','TB22'
                               ,'DC17','DC18','DC19','DC20','DC21','DC22','DC23','DC24') then '1'
            when t2.cash_tran_flg = '1' then '1'
            when t2.cash_tran_flg = '0' then '0'
            when t2.tran_cls_cd = '002' then '0'
            else '-'
        end as cash_trans_flg                -- 现转标志
      ,case when t5.acct_id is not null then '1' else '0' end as unexp_draw_flg           -- 提前支取标志
      ,t1.beps_unpasew_flg                           -- 小额免密标志
      ,''                                            -- 勾对标志
      ,case when t18.cross_bor_tran_flg ='1' then '1' 
              when t21.globalseqno is not null then '1' 
              else '0' end as cross_bor_tran_flg  -- 跨境交易标志
      ,t1.tran_termn_id                              -- 终端编号
      ,t1.tran_id                                    -- 交易代码
      ,t1.tran_descb                                 -- 交易描述
      ,''                                            -- 回单类型代码
      ,''                                            -- 交易名称
      ,t1.prpery_sys_code                            -- 外围系统编码
      ,t1.tran_ref_no                                -- 回单编号
      ,t1.tran_postsc                                -- 回单描述信息
      ,t4.public_agent_cust_id                       -- 代理人客户编号
      ,nvl(trim(t4.public_agent_name),t14.agent_name)                               -- 代理人名称
      ,nvl(trim(t4.public_agent_cert_type_cd),t14.agent_cert_type_cd)               -- 代理人证件类型代码
      ,nvl(trim(t4.public_agent_cert_no),t14.agent_cert_no)                         -- 代理人证件号码
      ,nvl(trim(t7.gender_cd),t14.agent_gender_cd)                                  -- 代理人性别代码
      ,nvl(trim(t4.public_agent_licen_issue_autho_cty_rg_cd),t14.agent_nation_cd)   -- 代理人国籍代码
      ,nvl(trim(t4.public_agent_cert_effect_dt),t14.agent_cert_start_dt)            -- 代办人证件生效日期
      ,nvl(trim(t4.public_agent_cert_invalid_dt),t14.agent_cert_exp_dt)             -- 代办人证件失效日期
      ,nvl(trim(t4.public_agent_tel_num),t14.agent_cont_num)                        -- 代理人联系电话
      ,t4.public_agent_licen_issue_autho_cty_rg_cd                                  -- 代理人发证机关所在地
      ,nvl(trim(t4.agent_reason),t14.agent_rs_descb)                                -- 代理原因
      ,t4.public_agent_rela                          -- 代理类型代码
      ,t8.cotas_cert_type_cd                         -- 经办人证件类型代码
      ,t8.cotas_cert_no                              -- 经办人证件号码
      ,t8.cotas_name                                 -- 经办人名称
      ,nvl(t16.cust_ip_num,t20.cust_ip_num)                           -- 客户端ip地址
      ,nvl(t19.cust_termn_mac_addr,t20.cust_termn_mac_addr)           -- 客户终端mac地址
      ,'1'                                           -- 记账标志
      ,t1.revs_dt                                    -- 冲正交易日期
      ,t1.revs_flow_num                              -- 冲正交易流水号
      ,t1.revs_tran_cd                               -- 冲正交易码
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')
 from ${iml_schema}.evt_dep_fin_tran_flow t1  --存款金融交易流水
 left join ${iol_schema}.ncbs_rb_tran_hist t0
   on t0.seq_no = t1.tran_flow_num
  and t0.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.ref_tran_code_para t2
   on t1.tran_cd = t2.tran_code
  and t2.bus_cls_cd = 'RB'
  and t2.job_cd ='ncbsf1'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.evt_public_agent_rgst_dtl t4 --代办人登记明细
  on t1.tran_ref_no = t4.tran_ref_no
  and t4.job_cd = 'ncbsi1'
  and t4.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
 left join (select distinct acct_id, tran_ref_no
               from ${iml_schema}.evt_reg_tran_flow
              where redt_type_cd in ('P', 'F')
				and job_cd = 'ncbsi1')	t5 --定期交易流水
   on t1.acct_id = t5.acct_id
  and t1.tran_ref_no = t5.tran_ref_no
 left join ${iml_schema}.pty_indv t7
   on t4.public_agent_cust_id = t7.party_id
  and t7.job_cd ='eifsf1'
  and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t7.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_01 t8
   on t1.acct_id = t8.acct_id
  and t8.rn = 1
 left join ${iol_schema}.ncbs_new_old_seq_no t9
   on t1.acct_id = t9.internal_key
 left join ${iol_schema}.cbss_kns_extd t13
   on t1.tran_ref_no = t13.trandt||t13.transq
  and t13.dttrcd like 'cs%'
 left join ${iml_schema}.pty_cust t27
   on t1.cust_id = t27.cust_id
  and t27.job_cd = 'eifsf1'
  and t27.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t27.id_mark <> 'D'
 left join (select t.*,row_number() over(partition by t.ova_flow_num order by t.ova_flow_num) as rn
              from ${iml_schema}.evt_intellge_brac_bus_flow t
             where t.job_cd = 'nibsi1'
               and t.tran_dt = to_date('${batch_date}','yyyymmdd')
               and t.etl_dt = to_date('${batch_date}','yyyymmdd')
               and trim(t.agent_name) is not null)t14
   on t1.ova_flow_num = t14.ova_flow_num
--  and t1.core_flow_num = t14.plat_flow_num
  and t14.rn=1
 left join ${iml_schema}.ref_tran_memo_code_para_tab t15
   on t1.memo_code = t15.memo_code
  and t15.job_cd = 'ncbsf1'
  and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join (select sorc_sys_flow_num,cust_ip_num,row_number() over(partition by sorc_sys_flow_num order by core_tran_dt) rn
              from ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_02 t16
              where trim(cust_ip_num) is not null) t16
   on t16.sorc_sys_flow_num = t1.ova_flow_num
--and t16.core_tran_dt = t1.tran_dt
  and t16.rn =1
 left join (select sorc_sys_flow_num,cust_termn_mac_addr,row_number() over(partition by sorc_sys_flow_num order by core_tran_dt) rn
              from ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_02 t16
              where trim(cust_termn_mac_addr) is not null) t19
   on t19.sorc_sys_flow_num = t1.ova_flow_num
--and t16.core_tran_dt = t1.tran_dt
  and t19.rn =1
 left join ${iml_schema}.agt_dep_acct_assis_info_h t17
   on t1.acct_id = t17.acct_id
  and t17.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t17.end_dt > to_date('${batch_date}','yyyymmdd')
  and t17.job_cd = 'ncbsf1'
 left join ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_03 t18
   on t1.ova_flow_num = t18.channel_seq_no
  and t1.tran_flow_num =t18.seq_no
  and t1.tran_dt=t18.tran_date
 left join ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_05 t20
   on t1.tran_ref_no=t20.tran_flow_num
  and t1.tran_dt =t20.tran_dt
  and t1.tran_flow_num =t20.acct_bill_flow_num
  and t20.rn=1
 left join (select distinct globalseqno 
                 from ${iol_schema}.mpcs_a10tibpsdetaillog 
                where date2='${batch_date}' 
                   and function2 like '%111%' ) t21
   on t1.ova_flow_num=t21.globalseqno
where t1.job_cd = 'ncbsi1'
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.tran_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;


--特殊处理步骤开始--
--2.21 因企业银行/手机银行日切时间晚于核心，部分外围交易流水日期与核心不一致，存在一天的差异，在1.4步骤中会有少量流水丢失，此段逻辑使用1.4数据再次更新C层存款流水表上日IP\MAC字段数据
--IP处理
merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using (select sorc_sys_flow_num,cust_ip_num,row_number() over(partition by sorc_sys_flow_num order by core_tran_dt) rn
              from ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_02
              where trim(cust_ip_num) is not null) t2
   on (t2.sorc_sys_flow_num = t1.ova_flow_num
  and t2.rn =1)
when matched then update set t1.client_ip_addr=t2.cust_ip_num
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')-1
and trim(t1.client_ip_addr) is null;
commit;
--MAC处理
merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using (select sorc_sys_flow_num,cust_termn_mac_addr,row_number() over(partition by sorc_sys_flow_num order by core_tran_dt) rn
              from ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_02
              where trim(cust_termn_mac_addr) is not null) t2
   on (t2.sorc_sys_flow_num = t1.ova_flow_num
  and t2.rn =1)
when matched then update set t1.cust_termn_mac_addr=t2.cust_termn_mac_addr
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')-1
and trim(t1.cust_termn_mac_addr) is null;
commit;

--2.22 20250110版本智能网点新增代理人补录登记簿，修改历史代理人信息，数仓不支持重跑历史，按照手动更新方式处理。
merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using (select init_tran_ova_flow_num      -- 原交易全局流水号
             ,init_tran_dt                -- 原交易日期
             ,public_agent_name           -- 代理人名称
             ,cert_type_cd                -- 代理人证件类型代码
             ,cert_no                     -- 代理人证件号码
             ,gender_cd                   -- 代理人性别代码
             ,nation_cd                   -- 代理人国籍代码
             ,cert_start_dt               -- 代办人证件生效日期
             ,cert_exp_dt                 -- 代办人证件失效日期
             ,cont_num                    -- 代理人联系电话
             ,licen_issue_autho_addr      -- 代理人发证机关所在地
             ,agent_reason_descb          -- 代理原因
             ,public_agent_type_cd        -- 代理类型代码
             ,row_number() over(partition by init_tran_ova_flow_num order by modif_dt desc) rn
         from ${iml_schema}.evt_public_agent_modif_flow
        where etl_dt = to_date('${batch_date}', 'yyyymmdd')) t2
   on (t2.init_tran_ova_flow_num = t1.ova_flow_num and t2.init_tran_dt=t1.etl_dt and t2.rn =1)
 when matched then update set
         t1.agent_name=t2.public_agent_name                                 --代理人名称
         ,t1.agent_cert_type_cd=t2.cert_type_cd                             --代理人证件类型代码
         ,t1.agent_cert_no=t2.cert_no                                       --代理人证件号码
         ,t1.agent_gender_cd=t2.gender_cd                                   --代理人性别代码
         ,t1.agent_nation_cd=t2.nation_cd                                   --代理人国籍代码
         ,t1.agent_cert_start_dt=t2.cert_start_dt                           --代理人证件开始日
         ,t1.agent_cert_exp_dt=t2.cert_exp_dt                               --代理人证件到期日
         ,t1.agent_phone=t2.cont_num                                        --代理人联系电话
         ,t1.agent_licen_issue_autho_site=t2.licen_issue_autho_addr         --代理人发证机关所在地
         ,t1.agent_rs=t2.agent_reason_descb                                 --代理原因
         ,t1.agent_type_cd=t2.public_agent_type_cd                          --代理类型代码
 where t1.etl_dt in (select distinct init_tran_dt from ${iml_schema}.evt_public_agent_modif_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd'))
;
commit;

--特殊处理步骤结束--


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_acct_tran_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_acct_tran_dtl_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_ex purge;

-- 3.2 drop temp table
--drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_dep_acct_tran_dtl', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);