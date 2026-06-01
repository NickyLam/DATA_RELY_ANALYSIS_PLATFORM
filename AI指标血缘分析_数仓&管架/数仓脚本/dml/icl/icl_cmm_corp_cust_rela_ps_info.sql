/*2.0
Purpose:    共性加工层-对公客户关联人信息：数据主要来源于ecif系统，包括我行客户类型为公司客户、企业担保客户、集团客户、同业客户对应的关联人信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_corp_cust_rela_ps_info
Createdate: 20201010
Logs:				20201010 谢宁 新建模型
            20210312 谢宁 nvl(trim(t15.phys_addr),trim(t17.phys_addr)) 增加一组T17逻辑
            20210312 谢宁 关联人为个人增加[关联人工作单位地址]取数逻辑coalesce(trim(t7.phys_addr),trim(t8.phys_addr),trim(t17.phys_addr))
            20210312 谢宁 修改个人关联人股东客户标志逻辑case when t2.rela_ps_rela_type_cd = '40100' then '1' else nvl(t3.attr_val,'0') end
            20210312 谢宁 修改【关联人高管标志】' '-->case when t2.rela_ps_rela_type_cd in ('30105','30104','30103','30101','30102','30100','30110','30107','30108') then '1' else '0' end
            20210324 陈伟峰 修改关联人（自然人）国籍，关联人最高学历取值逻辑，从pty_corp取（eifs2.0补充迁移字段）
            20210412 陈伟峰 新增字段【控制人纳税人识别号空值原因描述、控制人纳税人识别号、控制人纳税居民国家】
			      20220608 翟若平	调整第三组的取数数据源，由原对公信贷系统调整为综合信贷系统
			      20220708 温旺清 修改第一组的临时表T10 pty_party_elec_addr_h->pty_tel_info_h
			                      修改表pty_party_phys_addr_h的物理地址代码映射
			      20220716 曹永茂 【主要关联企业 customer_ship_mainrela】，因新信贷此功能已删除，该表未使用，调整模型删除该表
            20220805 温旺清 修改第二组临时表tmp_cmm_corp_cust_rela_ps_info_01加工逻辑，增加表icms_customer_relative的关联类型做筛选条件
            20220823 曹永茂 1、修改第二组t3的关联条件，由"inner join"改为"left join"
                            2、修改第二组临时表tmp_cmm_corp_cust_rela_ps_info_01的加工逻辑
                            3、修改第二组【关联人高管标志】【关联人股东标志】【法人代表标志】加工逻辑.
                            4、临时表tmp_cmm_corp_cust_rela_ps_info_01新增字段 src_table_name
            20220921 翟若平 1、调整第二组信贷的字段【关联人国别代码、关联人工作单位地址、关联人出生日期、关联人中文居住地址】的加工口径
                            2、置空第二组信贷的字段【关联人客户编号、关联人英文名称、关联人中文出生地址】
            20220921 曹永茂 1、因新信贷不再使用关联人客户编号，调整临时表tmp_cmm_corp_cust_rela_ps_info_01的【关联人编号】取数逻辑
                            2、调整临时表tmp_cmm_corp_cust_rela_ps_info_01中的过滤条件，高管的关系类型代码调整为：‘200’->‘30000’；上下游关联方的关系
                               类型代码调整为：‘05’->‘10210’; 配偶或家庭主要成员的关系类型代码调整为：'100'->'03'
            20221013 温旺清 增加tmp_cmm_corp_cust_rela_ps_info_01中各个关联子表的过滤条件，过滤掉各个关联子表关联人类型为null数据
            20221122 温旺清 新增字段【关联人最新更新时间、关联人最新更新柜员号、关联人最新更新机构号、关联人最新更新渠道代码】
            20221124 温旺清 根据新一代tel_type_cd代码映射调整关联人电话号码的口径
            20221203 曹永茂 1、调整信贷组过滤掉个人客户的条件：pty_cust -> pty_corp_cust. 因为 pty_cust.cust_type_cd 存在未知码值，无法通过该字段过滤掉个人客户
                            2、调整信贷组【关联人证件类型代码、关联人证件号码】的取数逻辑：
                               nvl(trim(t1.certtype), t2.cert_type_cd) -> t1.certtype
                               nvl(trim(t1.certid), t2.cert_no) -> t1.certid
            20221224 陈伟峰 调整ex01和ex02关联条件，使用rela_ps_id关联
            20230404 陈伟峰 调整字段【关联人电话号码,关联人姓名,关联人出生日期,关联人手机号码,法人代表标志,关联人最高学历代码,关联人证件失效日期,关联人工作单位地址,关联人英文名称,关联人中文出生地址,关联人国别代码,关联人中文居住地址,关联人编号,关联人证件号码,关联类型代码,关联人证件类型代码】取数逻辑，仅取ECIF
                            调整【关联人工作单位电话号码】取数逻辑，仅取信贷
            20230605 陈伟峰 新增字段【来源系统代码】
            20240227 陈伟峰 调整job_cd加工逻辑，从优先取信贷再取ECIF 调整成优先取ECIF再取信贷
            20240711 陈伟峰 新增字段【关联人联系地址】
            20240902 陈伟峰 新增字段【关联人性别代码、关联人职称等级代码、关联人职业代码、关联人工作单位名称、关联人工作单位性质代码、关联人其他职业描述、关联人月收入、关联人开户许可证、关联人所属集团号、关联人经营期限、关联人上级机构组织机构代码、关联人上级机构统一社会信用代码、关联人主管单位注册币种代码、关联人主管单位注册金额】
            20260123 陈伟峰 修改ECIF部分的关联人电话号码取数逻辑，增加取t01_corp_rel_per_info的phone_no数据
			20260407 周文龙 修改临时表的创建规则
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_cust_rela_ps_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_cust_rela_ps_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex purge;
drop table ${icl_schema}.tmp_cmm_corp_cust_rela_ps_info_01 purge;
drop table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex01 purge;
drop table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex02 purge;

-- 1.2 create table for exchage and add partition

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_cust_rela_ps_info where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex01
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_cust_rela_ps_info where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex02
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_cust_rela_ps_info where 0=1;

--第一组（共三组）ecif客户关联信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_rela_ps_info_ex01(
   etl_dt                    	                  --数据日期
   ,lp_id                    	                  --法人编号
	 ,cust_id                                     --客户编号
	 ,rela_type_cd                                --关联类型代码
	 ,rela_ps_cust_id                             --关联人客户编号
	 ,rela_ps_id                                  --关联人编号
	 ,rela_ps_name                                --关联人姓名
	 ,rela_ps_gender_cd                           --关联人性别代码
	 ,rela_ps_nation_cd                           --关联人国别代码
	 ,rela_ps_cert_type_cd                        --关联人证件类型代码
	 ,rela_ps_cert_no                             --关联人证件号码
	 ,rela_ps_cert_effect_dt                      --关联人证件生效日期
	 ,rela_ps_cert_exp_dt                         --关联人证件到期日期
	 ,rela_ps_higt_edu_cd                         --关联人最高学历代码
	 ,rela_ps_post_cd                             --关联人职务代码
	 ,rela_ps_senior_man_flg                      --关联人高管标志
	 ,rela_ps_shard_flg                           --关联人股东标志
	 ,legal_rep_flg                               --法人代表标志
	 ,rela_ps_tel_num                             --关联人电话号码
	 ,rela_ps_tel_ext_num                         --关联人电话分机号码
	 ,rela_ps_mobile_no                           --关联人手机号码
	 ,rela_ps_career_cd                           --关联人职业代码
   ,rela_ps_title_level_cd                      --关联人职称等级代码  
	 ,rela_ps_cont_addr                           --关联人联系地址
	 ,rela_ps_work_unit_name                      --关联人工作单位名称
	 ,rela_ps_work_unit_char_cd                   --关联人工作单位性质代码
	 ,rela_ps_work_unit_addr                      --关联人工作单位地址
	 ,rela_ps_work_unit_tel_num                   --关联人工作单位电话号码
   ,rela_ps_other_career_descb                  --关联人其他职业描述
   ,rela_ps_mon_inco                            --关联人月收入
   ,rela_ps_open_acct_lics                      --关联人开户许可证
   ,rela_ps_belong_group_num                    --关联人所属集团号
   ,rela_ps_mang_tenor                          --关联人经营期限
   ,rela_ps_super_org_orgnz_cd                  --关联人上级机构组织机构代码
   ,rela_ps_super_org_unify_soci_crdt_cd        --关联人上级机构统一社会信用代码
   ,rela_ps_director_corp_rgst_curr_cd          --关联人主管单位注册币种代码
   ,rela_ps_director_corp_rgst_amt              --关联人主管单位注册金额
	 ,rela_ps_en_last_name                        --关联人英文姓氏
	 ,rela_ps_en_name                             --关联人英文名称
	 ,rela_ps_stament_flg                         --关联人自证声明标志
	 ,rela_ps_tax_red_idti_cd                     --关联人税收居民身份代码
	 ,rela_ps_birth_dt                            --关联人出生日期
	 ,rela_ps_cn_birth_addr                       --关联人中文出生地址
	 ,rela_ps_en_birth_addr                       --关联人英文出生地址
	 ,rela_ps_cn_resdnt_addr                      --关联人中文居住地址
	 ,rela_ps_en_resdnt_addr                      --关联人英文居住地址
	 ,ctrler_type_cd                              --控制人类型代码
   ,ctrler_tax_null_rs_descb                    --控制人纳税人识别号空值原因描述
   ,ctrler_tax_num                              --控制人纳税人识别号
   ,ctrler_tax_red_cty                          --控制人纳税居民国家
	 ,rela_ps_post_name                           --关联人职务名称
	 ,rela_ps_latest_update_tm                    --关联人最新更新时间
   ,rela_ps_latest_update_teller_no             --关联人最新更新柜员号
   ,rela_ps_latest_update_org_no                --关联人最新更新机构号
   ,rela_ps_latest_update_chn_cd                --关联人最新更新渠道代码
   ,src_sys_cd                                  --来源系统代码
   ,job_cd                   	                  --任务代码
   ,etl_timestamp            	                  --etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')                                    --数据日期
      ,t1.lp_id                                                               --法人编号
			,t1.party_id                         																		--客户编号
			,t2.party_rela_type_cd               																		--关联类型代码
			,nvl(trim(t3.src_party_id),trim(t2.rela_party_id))  								  	--关联人客户编号
	    ,t2.rela_party_id                                                       --关联人编号
			,nvl(t5.party_name,t4.party_name)    																		--关联人姓名
			,t5.gender_cd                                                           --关联人性别代码
			,nvl(t5.nation_cd, t41.invtor_cty_cd)																		--关联人国别代码
			,t7.cert_type_cd                     																		--关联人证件类型代码
			,t7.cert_num                         																		--关联人证件号码
			,t7.cert_effect_dt                   																		--关联人证件生效日期
			,t7.cert_invalid_dt                  																		--关联人证件到期日期
			,t51.edu_cd                          																		--关联人最高学历代码
			,t9.post_cd                             																--关联人职务代码
			,case when t2.party_rela_type_cd = '30100' then '1' else '0' end        --关联人高管标志
			,case when t2.party_rela_type_cd = '40100' then '1' else '0' end	      --关联人股东标志
			,case when t2.party_rela_type_cd = '30101' then '1' else '0' end	   		--法人代表标志
			,coalesce(t10.home_phone, t10.other_phone, t10.fax ,t10.cont_num,t10.office_phone)      --关联人电话号码
			,''																																			--关联人电话分机号码
			,coalesce(t10.significant_phone, t10.mobile_phone)											--关联人手机号码
      ,t9.career_cd                                                           --关联人职业代码  
      ,t9.title_cd                                                            --关联人职称等级代码   
			,coalesce(t14.rela_addr, t15.rela_addr)							     			        	--关联人联系地址
      ,t9.work_unit_name                                                      --关联人工作单位名称     
      ,t9.work_unit_char_cd                                                   --关联人工作单位性质代码   
			,t9.work_unit_addr																											--关联人工作单位地址
			,t10.office_phone 																											--关联人工作单位电话号码
      ,t9.other_career                                                        --关联人其他职业描述
      ,nvl(t9.work_mon_inco,0)                                                --关联人月收入
      ,t14.assoc_open_lice                                                    --关联人开户许可证
      ,t14.rela_group_num                                                     --关联人所属集团号
      ,t14.oper_timelimit                                                     --关联人经营期限
      ,t6.super_orgnz_cd                                                      --关联人上级机构组织机构代码
      ,t6.super_unify_soci_crdt_cd                                            --关联人上级机构统一社会信用代码
      ,t6.director_corp_rgst_curr_cd                                          --关联人主管单位注册币种代码
      ,nvl(trim(t6.director_corp_rgst_amt),0)                                 --关联人主管单位注册金额
			,t12.ctrler_legal_en_last_name			 																		--关联人英文姓氏
			,t12.ctrler_legal_en_first_name		 											 								--关联人英文名称
			,t12.get_stament_flg            																				--关联人自证声明标志
			,nvl(t5.tax_resdnt_idti_type_cd,t6.tax_resdnt_idti_cd)							    --关联人税收居民身份代码
			,t5.birth_dt																						                --关联人出生日期
			,t12.ctrler_cn_birth_addr																						    --关联人中文出生地址
			,t12.ctrler_birth_cty_en_name																						--关联人英文出生地址
			,t12.ctrler_cn_resd_addr																						    --关联人中文居住地址
			,t12.ctrler_en_resd_addr																						    --关联人英文居住地址
			,nvl(t5.ctrler_type_cd,t6.ctrler_type_cd)															  --控制人类型代码
      ,t12.tax_num_null_rs_descb                                              --控制人纳税人识别号空值原因描述
      ,t12.tax_num                                                            --控制人纳税人识别号
      ,t12.distr_idtfy_num_cty_cd_comb                                        --控制人纳税居民国家
			,t8.attr_val               																						  --关联人职务名称
			,nvl(t14.last_updated_ts,t15.last_updated_ts)	                          --关联人最新更新时间
			,nvl(t14.last_updated_te,t15.last_updated_te)                           --关联人最新更新柜员号
			,nvl(t14.last_updated_org,t15.last_updated_org)                         --关联人最新更新机构号
			,nvl(t14.last_system_id,t15.last_system_id)                             --关联人最新更新渠道代码
		  ,'EIFS'                                                                 --来源系统代码
      ,t1.job_cd                                                              --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')        --etl处理时间戳
from ${iml_schema}.pty_party t1
inner join ${iml_schema}.pty_party_rela_h t2   --调整关联表
   on t1.party_id = t2.party_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party t3
	on t2.rela_party_id = t3.party_id
 and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t3.id_mark <> 'D'
 and t3.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_name_h t4
	on t2.rela_party_id = t4.party_id
 and t4.src_sys_cd = 'EIFS'
 and t4.party_name_type_cd = '01'
 and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 and t4.job_cd = 'eifsf1'
left join ${iml_schema}.pty_corp_rgst_info_h t41
	on t2.rela_party_id = t41.party_id
 and t41.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t41.end_dt > to_date('${batch_date}','yyyymmdd')
 and t41.job_cd = 'eifsf1'
left join ${iml_schema}.pty_indv t5
	on t2.rela_party_id = t5.party_id
 and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 and t5.job_cd = 'eifsf1'
 left join ${iml_schema}.pty_corp t6
	on t2.rela_party_id = t6.party_id
 and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t6.end_dt > to_date('${batch_date}','yyyymmdd')
 and t6.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_acdmic_record_h t51
	on t3.party_id = t51.party_id
 and t51.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t51.end_dt > to_date('${batch_date}','yyyymmdd')
 and t51.job_cd = 'eifsf1'
left join (select s1.*,
			            row_number() over(partition by s1.party_id order by nvl(trim(s1.main_cert_no_flg), '0') desc, s1.cert_effect_dt desc) as rn
             from ${iml_schema}.pty_party_cert_info_h s1
            where s1.start_dt <= to_date('${batch_date}','yyyymmdd')
              and s1.end_dt > to_date('${batch_date}','yyyymmdd')
              and s1.job_cd = 'eifsf1') t7
	on t2.rela_party_id = t7.party_id
 and t7.rn = 1
left join ${iml_schema}.pty_party_attr_h t8
	on t2.rela_party_id = t8.party_id
 and t8.attr_name = 'partyDuty'
 and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t8.end_dt > to_date('${batch_date}','yyyymmdd')
 and t8.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_work_info_h t9
  on t2.rela_party_id = t9.party_id
 and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t9.end_dt > to_date('${batch_date}','yyyymmdd')
 and t9.job_cd = 'eifsf1'
left join (select c.party_id,
							    max(decode(c.tel_type_cd, '07', c.tel_num)) significant_phone,
							    max(decode(c.tel_type_cd, '05', c.tel_num)) mobile_phone,
							    max(decode(c.tel_type_cd, '03', c.tel_num)) office_phone,
							    max(decode(c.tel_type_cd, '02', c.tel_num)) home_phone,
							    max(decode(c.tel_type_cd, '99', c.tel_num)) other_phone,
							    max(decode(c.tel_type_cd, '04', c.tel_num)) fax,
								max(case when c.tel_type_cd = '01' then c.tel_num else ' ' end) as cont_num  --联系电话
							    --max(decode(c.tel_type_cd, '006014', c.tel_num)) rela_zone_code
						from ${iml_schema}.pty_tel_info_h c
						where c.tel_type_cd in ('07' ,'05','03','02','99','04','01')
						  and c.job_cd = 'eifsf1'
						  and c.start_dt <= to_date('${batch_date}','yyyymmdd')
						  and c.end_dt > to_date('${batch_date}','yyyymmdd')
						group by c.party_id ) t10
	on t2.rela_party_id = t10.party_id
left join ${iml_schema}.pty_corp_ctrler_tax_h t12
 on t2.party_id = t12.party_id
 and t2.rela_party_id = t12.rela_party_id
 and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 and t12.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_status_h t13
	on t1.party_id = t13.party_id
 and t13.party_status_type_cd = 'CD1271'
 and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 and t13.job_cd = 'eifsf1'
left join ${iol_schema}.eifs_t01_corp_rel_corp_info t14
  on t2.rela_party_id=t14.rel_enterp_id
 and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t14.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.eifs_t01_corp_rel_per_info t15
  on t2.rela_party_id=t15.rel_id
 and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t15.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.party_type_cd in ('301004','301008','301007', '301005')
  and t2.valid_flg = '1'
  and t13.party_status_cd ='1'   --新一代变更
	--and t13.party_status_cd ='A'
	and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
  and t1.job_cd = 'eifsf1'
  and t2.src_table_name in ('eifs_t01_corp_rel_per_info','eifs_t01_corp_rel_corp_info', 'eifs_t01_corp_group_members');
commit;


-- 第二组（共二组）信贷对公客户关联人信息

--2.1 create tmp_cmm_corp_cust_rela_ps_info_01 table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_cust_rela_ps_info_01
nologging
compress ${option_switch} for query high
as
select cr.customerid as customerid,
       cr.relativeid as relativeid,
       (case when trim(csu.REGEDITCODE) is not null then '2020'  --组织机构代码
            when trim(csu.CREDITINSTITUTIONCODE) is not null then '2100' --机构信用代码证
            else '-'
            end) as certtype,
       (case when trim(csu.REGEDITCODE) is not null then csu.REGEDITCODE
             when trim(csu.CREDITINSTITUTIONCODE) is not null then csu.CREDITINSTITUTIONCODE
             else ' '
            end) as certid,
       '' as duty,
       csu.relationship  as relationship,
       '0' as telephone,
       '0' as mobiletelephone,
       '0' as worktel,
       csu.superorgname as customername,
       null as birthday,
       '' as ntlycd,
       '' as workaddress,
       '' as address,
       'icms_customer_ship_upcorp' as src_table_name
  from ${iol_schema}.icms_customer_relative cr, ${iol_schema}.icms_customer_ship_upcorp csu -- 上级机构信息表
 where cr.relativeid = csu.serialno
   and cr.relationship = '06'
   and trim(csu.relationship) is not null
   and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and csu.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and csu.end_dt > to_date('${batch_date}', 'yyyymmdd')
 union all
select cr.customerid as customerid,
       cr.relativeid as relativeid,
       cse.certtype as certtype,
       cse.certid as certid,
       cse.eduexperience as duty,
       cse.relationship  as relationship, -- 20222/06/19 zhairp 现在icms_customer_relative的relationship是200-单位客户关系，不是细化的个人与企业的关系
       nvl(trim(cse.telephone),'0') as telephone,
       '0' as mobiletelephone,
       nvl(trim(cse.officephone),'0') as worktel,
       cse.customername as customername,
       cse.birthday as birthday,
       cse.ntlycd,
       '' as workaddress,
       '' as address,
       'icms_customer_ship_executives'
  from ${iol_schema}.icms_customer_relative cr, ${iol_schema}.icms_customer_ship_executives cse -- 高管
 where cr.relativeid = cse.serialno
   and cr.relationship = '30000'
   and trim(cse.relationship) is not null
   and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and cse.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cse.end_dt > to_date('${batch_date}', 'yyyymmdd')
 union all
select cr.customerid as customerid,
       cr.relativeid as relativeid,
       cef.certtype as certtype,
       cef.certid as certid,
       '' as duty,
       cef.relationship  as relationship,
       '0' as telephone,
       '0' as mobiletelephone,
       '0' as worktel,
       cef.customername as customername,
       null as birthday,
       '' as ntlycd,
       '' as workaddress,
       '' as address,
       'icms_customer_executives_family'
  from ${iol_schema}.icms_customer_relative cr, ${iol_schema}.icms_customer_executives_family cef -- 主要关系人家族成员
 where cr.relativeid = cef.serialno
   and cr.relationship = '300'
   and trim(cef.relationship) is not null
   and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and cef.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cef.end_dt > to_date('${batch_date}', 'yyyymmdd')
 union all
select cr.customerid as customerid,
       cr.relativeid as relativeid,
       css.certtype as certtype,
       css.certid as certid,
       '' as duty,
       css.relationship  as relationship,
       '0' as telephone,
       '0' as mobiletelephone,
       '0' as worktel,
       css.customername as customername,
       null as birthday,
       css.countryorregion as ntlycd,
       '' as workaddress,
       '' as address,
       'icms_customer_ship_sharehold'
  from ${iol_schema}.icms_customer_relative cr, ${iol_schema}.icms_customer_ship_sharehold css -- 股东(出资人)
 where cr.relativeid = css.serialno
   and cr.relationship ='02'
   and trim(css.relationship) is not null
   and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and css.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and css.end_dt > to_date('${batch_date}', 'yyyymmdd')
 union all
select cr.customerid as customerid,
       cr.relativeid as relativeid,
       csi.certtype as certtype,
       csi.certid as certid,
       '' as duty,
       csi.relationship  as relationship,
       '0' as telephone,
       '0' as mobiletelephone,
       '0' as worktel,
       csi.customername as customername,
       null as birthday,
       '' as ntlycd,
       '' as workaddress,
       '' as address,
       'icms_customer_ship_invest'
  from ${iol_schema}.icms_customer_relative cr, ${iol_schema}.icms_customer_ship_invest csi -- 对外股权投资/投资企业情况
 where cr.relativeid = csi.serialno
   and cr.relationship ='04'
   and trim(csi.relationship) is not null
   and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and csi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and csi.end_dt > to_date('${batch_date}', 'yyyymmdd')
 union all
select cr.customerid as customerid,
       cr.relativeid as relativeid,
       csr.certtype as certtype,
       csr.certid as certid,
       '' as duty,
       csr.relationship  as relationship,
       '0' as telephone,
       '0' as mobiletelephone,
       '0' as worktel,
       csr.customername as customername,
       null as birthday,
       '' as ntlycd,
       '' as workaddress,
       '' as address,
       'icms_customer_ship_related'
  from ${iol_schema}.icms_customer_relative cr, ${iol_schema}.icms_customer_ship_related csr -- 上下游关联方
 where cr.relativeid = csr.serialno
   and cr.relationship  ='10210'
   and trim(csr.relationship) is not null
   and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and csr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and csr.end_dt > to_date('${batch_date}', 'yyyymmdd')
 union all
select cr.customerid as customerid,
       cr.relativeid as relativeid,
       csf.certtype as certtype,
       csf.certid as certid,
       csf.eduexperience as duty,
       csf.relationship as relationship,
       nvl(trim(csf.countryzone),'0') as telephone,
       nvl(trim(csf.indtel),'0') as mobiletelephone,
       csf.worktel as worktel,
       csf.customername as customername,
       to_date(trim(csf.birthday), 'yyyy/mm/dd') as birthday,
       '' as ntlycd,
       csf.workaddress,
       csf.address,
       'icms_customer_ship_family'
  from ${iol_schema}.icms_customer_relative cr, ${iol_schema}.icms_customer_ship_family csf -- 配偶或家庭主要成员情况
 where cr.relativeid = csf.serialno
   and cr.relationship ='03'
   and trim(csf.relationship) is not null
   and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and csf.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and csf.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_rela_ps_info_ex02(
   etl_dt                    	                  --数据日期
   ,lp_id                    	                  --法人编号
	 ,cust_id                                     --客户编号
	 ,rela_type_cd                                --关联类型代码
	 ,rela_ps_cust_id                             --关联人客户编号
	 ,rela_ps_id                                  --关联人编号
	 ,rela_ps_name                                --关联人姓名
	 ,rela_ps_gender_cd                           --关联人性别代码
	 ,rela_ps_nation_cd                           --关联人国别代码
	 ,rela_ps_cert_type_cd                        --关联人证件类型代码
	 ,rela_ps_cert_no                             --关联人证件号码
	 ,rela_ps_cert_effect_dt                      --关联人证件生效日期
	 ,rela_ps_cert_exp_dt                         --关联人证件到期日期
	 ,rela_ps_higt_edu_cd                         --关联人最高学历代码
	 ,rela_ps_post_cd                             --关联人职务代码
	 ,rela_ps_senior_man_flg                      --关联人高管标志
	 ,rela_ps_shard_flg                           --关联人股东标志
	 ,legal_rep_flg                               --法人代表标志
	 ,rela_ps_tel_num                             --关联人电话号码
	 ,rela_ps_tel_ext_num                         --关联人电话分机号码
	 ,rela_ps_mobile_no                           --关联人手机号码
	 ,rela_ps_career_cd                           --关联人职业代码
	 ,rela_ps_title_level_cd                      --关联人职称等级代码
	 ,rela_ps_cont_addr                           --关联人联系地址
	 ,rela_ps_work_unit_name                      --关联人工作单位名称
	 ,rela_ps_work_unit_char_cd                   --关联人工作单位性质代码
	 ,rela_ps_work_unit_addr                      --关联人工作单位地址
	 ,rela_ps_work_unit_tel_num                   --关联人工作单位电话号码
   ,rela_ps_other_career_descb                  --关联人其他职业描述
   ,rela_ps_mon_inco                            --关联人月收入
   ,rela_ps_open_acct_lics                      --关联人开户许可证
   ,rela_ps_belong_group_num                    --关联人所属集团号
   ,rela_ps_mang_tenor                          --关联人经营期限
   ,rela_ps_super_org_orgnz_cd                  --关联人上级机构组织机构代码
   ,rela_ps_super_org_unify_soci_crdt_cd        --关联人上级机构统一社会信用代码
   ,rela_ps_director_corp_rgst_curr_cd          --关联人主管单位注册币种代码
   ,rela_ps_director_corp_rgst_amt              --关联人主管单位注册金额
	 ,rela_ps_en_last_name                        --关联人英文姓氏
	 ,rela_ps_en_name                             --关联人英文名称
	 ,rela_ps_stament_flg                         --关联人自证声明标志
	 ,rela_ps_tax_red_idti_cd                     --关联人税收居民身份代码
	 ,rela_ps_birth_dt                            --关联人出生日期
	 ,rela_ps_cn_birth_addr                       --关联人中文出生地址
	 ,rela_ps_en_birth_addr                       --关联人英文出生地址
	 ,rela_ps_cn_resdnt_addr                      --关联人中文居住地址
	 ,rela_ps_en_resdnt_addr                      --关联人英文居住地址
	 ,ctrler_type_cd                              --控制人类型代码
   ,ctrler_tax_null_rs_descb                    --控制人纳税人识别号空值原因描述
   ,ctrler_tax_num                              --控制人纳税人识别号
   ,ctrler_tax_red_cty                          --控制人纳税居民国家
	 ,rela_ps_post_name                           --关联人职务名称
	 ,rela_ps_latest_update_tm                    --关联人最新更新时间
   ,rela_ps_latest_update_teller_no             --关联人最新更新柜员号
   ,rela_ps_latest_update_org_no                --关联人最新更新机构号
   ,rela_ps_latest_update_chn_cd                --关联人最新更新渠道代码
   ,src_sys_cd                                  --来源系统代码
   ,job_cd                   	                  --任务代码
   ,etl_timestamp            	                  --etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')                                                               -- 数据日期
       ,'9999'	                                                                                         -- 法人编号
       ,t1.customerid                                                                                    -- 客户编号
       ,t1.relationship                                                                                  -- 关联类型代码
       ,''                                                                                               -- 关联人客户编号
       ,t1.relativeid                                                                                    -- 关联人编号
       ,t1.customername                                                                                  -- 关联人姓名
	     ,''                                                                                              -- 关联人性别代码
       ,nvl(trim(t1.ntlycd),'XXX') as rela_ps_nation_cd                                                  -- 关联人国别代码
       ,t1.certtype                                                                                      -- 关联人证件类型代码
       ,t1.certid                                                                                        -- 关联人证件号码
       ,''                                                                                               -- 关联人证件生效日期
       ,''                                                                                               -- 关联人证件到期日期
       ,t1.duty                                                                                          -- 关联人最高学历代码
       ,''                                                                                               -- 关联人职务代码
       ,case when t1.relationship like '301%'
	         then '1' else '0' end as rela_ps_senior_man_flg                                               -- 关联人高管标志
       ,case when t1.relationship like '401%'
	         then '1' else '0' end as rela_ps_shard_flg                                                    -- 关联人股东标志
       ,case when t1.relationship = '30101'
	         then '1' else '0' end as legal_rep_flg                                                        -- 法人代表标志
       ,t1.telephone                                                                                     -- 关联人电话号码
       ,''                                                                                               -- 关联人电话分机号码
       ,t1.mobiletelephone                                                                               -- 关联人手机号码
	     ,' '                                                                                              -- 关联人职业代码
	     ,' '                                                                                              -- 关联人职称等级代码
	     ,' '                                                                                              -- 关联人联系地址
	     ,' '                                                                                              -- 关联人工作单位名称
	     ,' '                                                                                              -- 关联人工作单位性质代码
       ,t1.workaddress                                                                                   -- 关联人工作单位地址
       ,t1.worktel                                                                                       -- 关联人工作单位电话号码
       ,' '                                                                                              -- 关联人其他职业描述
       ,0                                                                                                -- 关联人月收入
       ,' '                                                                                              -- 关联人开户许可证
       ,' '                                                                                              -- 关联人所属集团号
       ,' '                                                                                              -- 关联人经营期限
       ,' '                                                                                              -- 关联人上级机构组织机构代码
       ,' '                                                                                              -- 关联人上级机构统一社会信用代码
       ,' '                                                                                              -- 关联人主管单位注册币种代码
       ,0                                                                                                -- 关联人主管单位注册金额
       ,''                                                                                               -- 关联人英文姓氏
       ,''                                                                                               -- 关联人英文名称
       ,'-'                                                                                              -- 关联人自证声明标志
       ,''                                                                                               -- 关联人税收居民身份代码
       ,t1.birthday                                                                                      -- 关联人出生日期
       ,''                                                                                               -- 关联人中文出生地址
       ,''                                                                                               -- 关联人英文出生地址
       ,t1.address                                                                                       -- 关联人中文居住地址
       ,''                                                                                               -- 关联人英文居住地址
       ,'-'                                                                                              -- 控制人类型代码
       ,''                                                                                               -- 控制人纳税人识别号空值原因描述
       ,''                                                                                               -- 控制人纳税人识别号
       ,''                                                                                               -- 控制人纳税居民国家
       ,''                                                                                               -- 关联人职务名称
       ,'' 	                                                                                             -- 关联人最新更新时间
       ,''                                                                                                -- 关联人最新更新柜员号
       ,''                                                                                                -- 关联人最新更新机构号
       ,''                                                                                                -- 关联人最新更新渠道代码
       ,'ICMS'                                                                                            -- 来源系统代码
       ,'icmsf1'
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                  -- etl处理时间戳
  from ${icl_schema}.tmp_cmm_corp_cust_rela_ps_info_01 t1
 inner join ${iml_schema}.pty_corp_cust t2
    on t1.customerid = t2.cust_id
	 and t2.cust_id not in ('2015090700000114',
                           '2014060300000006',
                           '2013041000000004',
                           '2013120300000025',
                           '2013061300000012',
                           '2013022800000015',
                           '2014061000000019',
                           '2014101700000011',
                           '#OwnerID',
                           '2015081300000033') -- 排除冗余客户
   and not exists (select 1
                     from ${iol_schema}.icms_group_info gi
                    where t2.cust_id = gi.groupid
                      and gi.groupcredittype = '02'
                      and t2.corp_cust_type_cd = '5')
   and t2.job_cd = 'icmsf1'
   and t2.id_mark<>'D'
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 where 1 = 1;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_rela_ps_info_ex(
   etl_dt                    	                  --数据日期
   ,lp_id                    	                  --法人编号
	 ,cust_id                                     --客户编号
	 ,rela_type_cd                                --关联类型代码
	 ,rela_ps_cust_id                             --关联人客户编号
	 ,rela_ps_id                                  --关联人编号
	 ,rela_ps_name                                --关联人姓名
	 ,rela_ps_gender_cd                           --关联人性别代码
	 ,rela_ps_nation_cd                           --关联人国别代码
	 ,rela_ps_cert_type_cd                        --关联人证件类型代码
	 ,rela_ps_cert_no                             --关联人证件号码
	 ,rela_ps_cert_effect_dt                      --关联人证件生效日期
	 ,rela_ps_cert_exp_dt                         --关联人证件到期日期
	 ,rela_ps_higt_edu_cd                         --关联人最高学历代码
	 ,rela_ps_post_cd                             --关联人职务代码
	 ,rela_ps_senior_man_flg                      --关联人高管标志
	 ,rela_ps_shard_flg                           --关联人股东标志
	 ,legal_rep_flg                               --法人代表标志
	 ,rela_ps_tel_num                             --关联人电话号码
	 ,rela_ps_tel_ext_num                         --关联人电话分机号码
	 ,rela_ps_mobile_no                           --关联人手机号码
	 ,rela_ps_career_cd                           --关联人职业代码
	 ,rela_ps_title_level_cd                      --关联人职称等级代码
	 ,rela_ps_cont_addr                           --关联人联系地址
	 ,rela_ps_work_unit_name                      --关联人工作单位名称
	 ,rela_ps_work_unit_char_cd                   --关联人工作单位性质代码
	 ,rela_ps_work_unit_addr                      --关联人工作单位地址
	 ,rela_ps_work_unit_tel_num                   --关联人工作单位电话号码
   ,rela_ps_other_career_descb                  --关联人其他职业描述
   ,rela_ps_mon_inco                            --关联人月收入
   ,rela_ps_open_acct_lics                      --关联人开户许可证
   ,rela_ps_belong_group_num                    --关联人所属集团号
   ,rela_ps_mang_tenor                          --关联人经营期限
   ,rela_ps_super_org_orgnz_cd                  --关联人上级机构组织机构代码
   ,rela_ps_super_org_unify_soci_crdt_cd        --关联人上级机构统一社会信用代码
   ,rela_ps_director_corp_rgst_curr_cd          --关联人主管单位注册币种代码
   ,rela_ps_director_corp_rgst_amt              --关联人主管单位注册金额
	 ,rela_ps_en_last_name                        --关联人英文姓氏
	 ,rela_ps_en_name                             --关联人英文名称
	 ,rela_ps_stament_flg                         --关联人自证声明标志
	 ,rela_ps_tax_red_idti_cd                     --关联人税收居民身份代码
	 ,rela_ps_birth_dt                            --关联人出生日期
	 ,rela_ps_cn_birth_addr                       --关联人中文出生地址
	 ,rela_ps_en_birth_addr                       --关联人英文出生地址
	 ,rela_ps_cn_resdnt_addr                      --关联人中文居住地址
	 ,rela_ps_en_resdnt_addr                      --关联人英文居住地址
	 ,ctrler_type_cd                              --控制人类型代码
   ,ctrler_tax_null_rs_descb                    --控制人纳税人识别号空值原因描述
   ,ctrler_tax_num                              --控制人纳税人识别号
   ,ctrler_tax_red_cty                          --控制人纳税居民国家
	 ,rela_ps_post_name                           --关联人职务名称
	 ,rela_ps_latest_update_tm                    --关联人最新更新时间
   ,rela_ps_latest_update_teller_no             --关联人最新更新柜员号
   ,rela_ps_latest_update_org_no                --关联人最新更新机构号
   ,rela_ps_latest_update_chn_cd                --关联人最新更新渠道代码
   ,src_sys_cd                                  --来源系统代码
   ,job_cd                   	                  --任务代码
   ,etl_timestamp            	                  --etl处理时间戳
)
select
	t1.etl_dt                                                                  -- 数据日期
	,t1.lp_id                                                                  -- 法人编号
	,nvl(trim(t2.cust_id),t1.cust_id)                                          -- 客户编号
	,t1.rela_type_cd                                                           -- 关联类型代码
	,nvl(trim(t2.rela_ps_cust_id),t1.rela_ps_cust_id)                          -- 关联人客户编号
  ,t1.rela_ps_id                                                             -- 关联人编号
	,t1.rela_ps_name                                                           -- 关联人姓名
  ,t1.rela_ps_gender_cd                                                      -- 关联人性别代码
	,nvl(t1.rela_ps_nation_cd,'XXX')                                           -- 关联人国别代码
	,nvl(t1.rela_ps_cert_type_cd,'0000')                                       -- 关联人证件类型代码
	,t1.rela_ps_cert_no                                                        -- 关联人证件号码
	,nvl(trim(t2.rela_ps_cert_effect_dt),t1.rela_ps_cert_effect_dt)            -- 关联人证件生效日期
	,t1.rela_ps_cert_exp_dt                                                    -- 关联人证件到期日期
	,nvl(t1.rela_ps_higt_edu_cd,'00')                                          -- 关联人最高学历代码
	,nvl(trim(t2.rela_ps_post_cd),t1.rela_ps_post_cd)                          -- 关联人职务代码
	,nvl(replace(trim(t2.rela_ps_senior_man_flg),'','0'),replace(trim(t1.rela_ps_senior_man_flg),'','0'))      -- 关联人高管标志
	,nvl(replace(trim(t2.rela_ps_shard_flg),'','0'),replace(trim(t1.rela_ps_shard_flg),'','0'))                -- 关联人股东标志
	,replace(trim(t1.legal_rep_flg),'','0')                                    -- 法人代表标志
	,t1.rela_ps_tel_num                                                        -- 关联人电话号码
	,nvl(trim(t2.rela_ps_tel_ext_num),t1.rela_ps_tel_ext_num)                  -- 关联人电话分机号码
	,t1.rela_ps_mobile_no                                                      -- 关联人手机号码
	,t1.rela_ps_career_cd                                                      -- 关联人职业代码
	,t1.rela_ps_title_level_cd                                                 -- 关联人职称等级代码
	,t1.rela_ps_cont_addr                                                      -- 关联人联系地址
	,t1.rela_ps_work_unit_name                                                 -- 关联人工作单位名称
	,t1.rela_ps_work_unit_char_cd                                              -- 关联人工作单位性质代码
	,t1.rela_ps_work_unit_addr                                                 -- 关联人工作单位地址
	,t2.rela_ps_work_unit_tel_num                                              -- 关联人工作单位电话号码
  ,t1.rela_ps_other_career_descb                                             -- 关联人其他职业描述
  ,t1.rela_ps_mon_inco                                                       -- 关联人月收入
  ,t1.rela_ps_open_acct_lics                                                 -- 关联人开户许可证
  ,t1.rela_ps_belong_group_num                                               -- 关联人所属集团号
  ,t1.rela_ps_mang_tenor                                                     -- 关联人经营期限
  ,t1.rela_ps_super_org_orgnz_cd                                             -- 关联人上级机构组织机构代码
  ,t1.rela_ps_super_org_unify_soci_crdt_cd                                   -- 关联人上级机构统一社会信用代码
  ,t1.rela_ps_director_corp_rgst_curr_cd                                     -- 关联人主管单位注册币种代码
  ,t1.rela_ps_director_corp_rgst_amt                                         -- 关联人主管单位注册金额
	,nvl(trim(t2.rela_ps_en_last_name),t1.rela_ps_en_last_name)                -- 关联人英文姓氏
	,t1.rela_ps_en_name                                                        -- 关联人英文名称
	,nvl(trim(t2.rela_ps_stament_flg),t1.rela_ps_stament_flg)                  -- 关联人自证声明标志
	,nvl(trim(t2.rela_ps_tax_red_idti_cd),t1.rela_ps_tax_red_idti_cd)          -- 关联人税收居民身份代码
	,t1.rela_ps_birth_dt                                                       -- 关联人出生日期
	,t1.rela_ps_cn_birth_addr                                                  -- 关联人中文出生地址
	,nvl(trim(t2.rela_ps_en_birth_addr),t1.rela_ps_en_birth_addr)              -- 关联人英文出生地址
	,t1.rela_ps_cn_resdnt_addr                                                 -- 关联人中文居住地址
	,nvl(trim(t2.rela_ps_en_resdnt_addr),t1.rela_ps_en_resdnt_addr)            -- 关联人英文居住地址
	,nvl(trim(t2.ctrler_type_cd),t1.ctrler_type_cd)                            -- 控制人类型代码
	,nvl(trim(t2.ctrler_tax_null_rs_descb),t1.ctrler_tax_null_rs_descb)        -- 控制人纳税人识别号空值原因描述
	,nvl(trim(t2.ctrler_tax_num),t1.ctrler_tax_num)                            -- 控制人纳税人识别号
	,nvl(trim(t2.ctrler_tax_red_cty),t1.ctrler_tax_red_cty)                    -- 控制人纳税居民国家
	,nvl(trim(t2.rela_ps_post_name),t1.rela_ps_post_name)                      -- 关联人职务名称
  ,t1.rela_ps_latest_update_tm                                               -- 关联人最新更新时间
  ,t1.rela_ps_latest_update_teller_no                                        -- 关联人最新更新柜员号
  ,t1.rela_ps_latest_update_org_no                                           -- 关联人最新更新机构号
  ,t1.rela_ps_latest_update_chn_cd                                           -- 关联人最新更新渠道代码
  ,nvl(trim(t1.src_sys_cd),t2.src_sys_cd)                                    -- 来源系统代码
	,(case when t1.cust_id is not null then t1.job_cd else t2.job_cd end)      -- 任务代码
	,t1.etl_timestamp                                                          -- 数据处理时间
from ${icl_schema}.cmm_corp_cust_rela_ps_info_ex01 t1
left join ${icl_schema}.cmm_corp_cust_rela_ps_info_ex02 t2
	 on t1.cust_id = t2.cust_id
	and t1.rela_type_cd = t2.rela_type_cd
	and t1.rela_ps_id = t2.rela_ps_id
	and t1.rela_ps_cert_type_cd = t2.rela_ps_cert_type_cd
where 1 = 1 ;

commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_rela_ps_info_ex(
   etl_dt                    	                  --数据日期
   ,lp_id                    	                  --法人编号
	 ,cust_id                                     --客户编号
	 ,rela_type_cd                                --关联类型代码
	 ,rela_ps_cust_id                             --关联人客户编号
	 ,rela_ps_id                                  --关联人编号
	 ,rela_ps_name                                --关联人姓名
	 ,rela_ps_gender_cd                           --关联人性别代码
	 ,rela_ps_nation_cd                           --关联人国别代码
	 ,rela_ps_cert_type_cd                        --关联人证件类型代码
	 ,rela_ps_cert_no                             --关联人证件号码
	 ,rela_ps_cert_effect_dt                      --关联人证件生效日期
	 ,rela_ps_cert_exp_dt                         --关联人证件到期日期
	 ,rela_ps_higt_edu_cd                         --关联人最高学历代码
	 ,rela_ps_post_cd                             --关联人职务代码
	 ,rela_ps_senior_man_flg                      --关联人高管标志
	 ,rela_ps_shard_flg                           --关联人股东标志
	 ,legal_rep_flg                               --法人代表标志
	 ,rela_ps_tel_num                             --关联人电话号码
	 ,rela_ps_tel_ext_num                         --关联人电话分机号码
	 ,rela_ps_mobile_no                           --关联人手机号码
	 ,rela_ps_career_cd                           --关联人职业代码
	 ,rela_ps_title_level_cd                      --关联人职称等级代码
	 ,rela_ps_cont_addr                           --关联人联系地址
	 ,rela_ps_work_unit_name                      --关联人工作单位名称
	 ,rela_ps_work_unit_char_cd                   --关联人工作单位性质代码
	 ,rela_ps_work_unit_addr                      --关联人工作单位地址
	 ,rela_ps_work_unit_tel_num                   --关联人工作单位电话号码
   ,rela_ps_other_career_descb                  --关联人其他职业描述
   ,rela_ps_mon_inco                            --关联人月收入
   ,rela_ps_open_acct_lics                      --关联人开户许可证
   ,rela_ps_belong_group_num                    --关联人所属集团号
   ,rela_ps_mang_tenor                          --关联人经营期限
   ,rela_ps_super_org_orgnz_cd                  --关联人上级机构组织机构代码
   ,rela_ps_super_org_unify_soci_crdt_cd        --关联人上级机构统一社会信用代码
   ,rela_ps_director_corp_rgst_curr_cd          --关联人主管单位注册币种代码
   ,rela_ps_director_corp_rgst_amt              --关联人主管单位注册金额
	 ,rela_ps_en_last_name                        --关联人英文姓氏
	 ,rela_ps_en_name                             --关联人英文名称
	 ,rela_ps_stament_flg                         --关联人自证声明标志
	 ,rela_ps_tax_red_idti_cd                     --关联人税收居民身份代码
	 ,rela_ps_birth_dt                            --关联人出生日期
	 ,rela_ps_cn_birth_addr                       --关联人中文出生地址
	 ,rela_ps_en_birth_addr                       --关联人英文出生地址
	 ,rela_ps_cn_resdnt_addr                      --关联人中文居住地址
	 ,rela_ps_en_resdnt_addr                      --关联人英文居住地址
	 ,ctrler_type_cd                              --控制人类型代码
   ,ctrler_tax_null_rs_descb                    --控制人纳税人识别号空值原因描述
   ,ctrler_tax_num                              --控制人纳税人识别号
   ,ctrler_tax_red_cty                          --控制人纳税居民国家
	 ,rela_ps_post_name                           --关联人职务名称
	 ,rela_ps_latest_update_tm                    --关联人最新更新时间
   ,rela_ps_latest_update_teller_no             --关联人最新更新柜员号
   ,rela_ps_latest_update_org_no                --关联人最新更新机构号
   ,rela_ps_latest_update_chn_cd                --关联人最新更新渠道代码
   ,src_sys_cd                                  --来源系统代码
   ,job_cd                   	                  --任务代码
   ,etl_timestamp            	                  --etl处理时间戳
)
select
	  t1.etl_dt                                   --数据日期
   ,t1.lp_id                                    --法人编号
	 ,t1.cust_id                                  --客户编号
	 ,t1.rela_type_cd                             --关联类型代码
	 ,t1.rela_ps_cust_id                          --关联人客户编号
	 ,t1.rela_ps_id                               --关联人编号
	 ,t1.rela_ps_name                             --关联人姓名
	 ,t1.rela_ps_gender_cd                        --关联人性别代码
	 ,t1.rela_ps_nation_cd                        --关联人国别代码
	 ,t1.rela_ps_cert_type_cd                     --关联人证件类型代码
	 ,t1.rela_ps_cert_no                          --关联人证件号码
	 ,t1.rela_ps_cert_effect_dt                   --关联人证件生效日期
	 ,t1.rela_ps_cert_exp_dt                      --关联人证件到期日期
	 ,nvl(trim(t1.rela_ps_higt_edu_cd),'00')      --关联人最高学历代码
	 ,t1.rela_ps_post_cd                          --关联人职务代码
	 ,t1.rela_ps_senior_man_flg                   --关联人高管标志
	 ,t1.rela_ps_shard_flg                        --关联人股东标志
	 ,t1.legal_rep_flg                            --法人代表标志
	 ,t1.rela_ps_tel_num                          --关联人电话号码
	 ,t1.rela_ps_tel_ext_num                      --关联人电话分机号码
	 ,t1.rela_ps_mobile_no                        --关联人手机号码
	 ,t1.rela_ps_career_cd                        --关联人职业代码
	 ,t1.rela_ps_title_level_cd                   --关联人职称等级代码
	 ,t1.rela_ps_cont_addr                        --关联人联系地址
	 ,t1.rela_ps_work_unit_name                   --关联人工作单位名称
	 ,t1.rela_ps_work_unit_char_cd                --关联人工作单位性质代码
	 ,t1.rela_ps_work_unit_addr                   --关联人工作单位地址
	 ,t1.rela_ps_work_unit_tel_num                --关联人工作单位电话号码
   ,t1.rela_ps_other_career_descb               --关联人其他职业描述
   ,t1.rela_ps_mon_inco                         --关联人月收入
   ,t1.rela_ps_open_acct_lics                   --关联人开户许可证
   ,t1.rela_ps_belong_group_num                 --关联人所属集团号
   ,t1.rela_ps_mang_tenor                       --关联人经营期限
   ,t1.rela_ps_super_org_orgnz_cd               --关联人上级机构组织机构代码
   ,t1.rela_ps_super_org_unify_soci_crdt_cd     --关联人上级机构统一社会信用代码
   ,t1.rela_ps_director_corp_rgst_curr_cd       --关联人主管单位注册币种代码
   ,t1.rela_ps_director_corp_rgst_amt           --关联人主管单位注册金额
	 ,t1.rela_ps_en_last_name                     --关联人英文姓氏
	 ,t1.rela_ps_en_name                          --关联人英文名称
	 ,t1.rela_ps_stament_flg                      --关联人自证声明标志
	 ,t1.rela_ps_tax_red_idti_cd                  --关联人税收居民身份代码
	 ,t1.rela_ps_birth_dt                         --关联人出生日期
	 ,t1.rela_ps_cn_birth_addr                    --关联人中文出生地址
	 ,t1.rela_ps_en_birth_addr                    --关联人英文出生地址
	 ,t1.rela_ps_cn_resdnt_addr                   --关联人中文居住地址
	 ,t1.rela_ps_en_resdnt_addr                   --关联人英文居住地址
	 ,t1.ctrler_type_cd                           --控制人类型代码
   ,t1.ctrler_tax_null_rs_descb                 --控制人纳税人识别号空值原因描述
   ,t1.ctrler_tax_num                           --控制人纳税人识别号
   ,t1.ctrler_tax_red_cty                       --控制人纳税居民国家
	 ,t1.rela_ps_post_name                        --关联人职务名称
	 ,t1.rela_ps_latest_update_tm                 --关联人最新更新时间
   ,t1.rela_ps_latest_update_teller_no          --关联人最新更新柜员号
   ,t1.rela_ps_latest_update_org_no             --关联人最新更新机构号
   ,t1.rela_ps_latest_update_chn_cd             --关联人最新更新渠道代码
   ,t1.src_sys_cd                               --来源系统代码
   ,t1.job_cd                                   --任务代码
   ,t1.etl_timestamp                            --etl处理时间戳
 from ${icl_schema}.cmm_corp_cust_rela_ps_info_ex02 t1
where not exists (select 1 from ${icl_schema}.cmm_corp_cust_rela_ps_info_ex01 t2
									 where t1.cust_id = t2.cust_id
									 	 and t1.rela_type_cd = t2.rela_type_cd
 								  	 and t1.rela_ps_id = t2.rela_ps_id
 									   and t1.rela_ps_cert_type_cd = t2.rela_ps_cert_type_cd);
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_cust_rela_ps_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex purge;
--drop table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex01 purge;
--drop table ${icl_schema}.cmm_corp_cust_rela_ps_info_ex02 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_cust_rela_ps_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);