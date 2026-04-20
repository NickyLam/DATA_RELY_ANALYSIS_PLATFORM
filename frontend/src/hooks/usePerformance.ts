/**
 * 性能优化 Hooks
 * 提供懒加载、防抖、节流、缓存等功能
 */

import { useCallback, useEffect, useRef, useState, useMemo } from 'react';

// 防抖 Hook
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}

// 节流 Hook
export function useThrottle<T extends (...args: any[]) => any>(
  callback: T,
  delay: number
): T {
  const lastRun = useRef(Date.now());

  return useCallback(
    ((...args: any[]) => {
      const now = Date.now();
      if (now - lastRun.current >= delay) {
        lastRun.current = now;
        return callback(...args);
      }
    }) as T,
    [callback, delay]
  );
}

// 懒加载 Hook
export function useLazyLoad(
  callback: () => Promise<void>,
  options?: {
    threshold?: number;
    rootMargin?: string;
    enabled?: boolean;
  }
): {
  ref: React.RefObject<HTMLDivElement>;
  isLoading: boolean;
  error: Error | null;
} {
  const { threshold = 0, rootMargin = '100px', enabled = true } = options || {};
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  const ref = useRef<HTMLDivElement>(null);
  const loadingRef = useRef(false);

  useEffect(() => {
    if (!enabled) return;

    const element = ref.current;
    if (!element) return;

    const observer = new IntersectionObserver(
      async (entries) => {
        if (entries[0].isIntersecting && !loadingRef.current) {
          loadingRef.current = true;
          setIsLoading(true);
          setError(null);

          try {
            await callback();
          } catch (err) {
            setError(err instanceof Error ? err : new Error(String(err)));
          } finally {
            setIsLoading(false);
            loadingRef.current = false;
          }
        }
      },
      { threshold, rootMargin }
    );

    observer.observe(element);

    return () => {
      observer.disconnect();
    };
  }, [callback, threshold, rootMargin, enabled]);

  return { ref, isLoading, error };
}

// 无限滚动 Hook
export function useInfiniteScroll<T>(
  fetchMore: () => Promise<T[]>,
  options?: {
    threshold?: number;
    initialData?: T[];
    maxItems?: number;
  }
): {
  data: T[];
  isLoading: boolean;
  hasMore: boolean;
  loadMore: () => Promise<void>;
  reset: () => void;
} {
  const { threshold = 100, initialData = [], maxItems = 1000 } = options || {};
  const [data, setData] = useState<T[]>(initialData);
  const [isLoading, setIsLoading] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const loadingRef = useRef(false);

  const loadMore = useCallback(async () => {
    if (loadingRef.current || !hasMore || data.length >= maxItems) {
      return;
    }

    loadingRef.current = true;
    setIsLoading(true);

    try {
      const newItems = await fetchMore();
      if (newItems.length === 0) {
        setHasMore(false);
      } else {
        setData((prev) => [...prev, ...newItems]);
      }
    } catch (error) {
      console.error('Failed to load more items:', error);
    } finally {
      setIsLoading(false);
      loadingRef.current = false;
    }
  }, [fetchMore, hasMore, data.length, maxItems]);

  const reset = useCallback(() => {
    setData(initialData);
    setHasMore(true);
    loadingRef.current = false;
  }, [initialData]);

  return { data, isLoading, hasMore, loadMore, reset };
}

// 缓存 Hook
interface CacheOptions {
  ttl?: number;
  maxSize?: number;
}

export function useCache<T>(
  key: string,
  fetcher: () => Promise<T>,
  options?: CacheOptions
): {
  data: T | null;
  isLoading: boolean;
  error: Error | null;
  refetch: () => Promise<void>;
  clearCache: () => void;
} {
  const { ttl = 5 * 60 * 1000, maxSize = 50 } = options || {};
  const [data, setData] = useState<T | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  const cacheRef = useRef<Map<string, { data: T; timestamp: number }>>(new Map());

  const clearCache = useCallback(() => {
    cacheRef.current.delete(key);
    setData(null);
  }, [key]);

  const refetch = useCallback(async () => {
    setIsLoading(true);
    setError(null);

    try {
      const result = await fetcher();
      setData(result);

      // 缓存结果
      if (cacheRef.current.size >= maxSize) {
        const oldestKey = cacheRef.current.keys().next().value;
        cacheRef.current.delete(oldestKey);
      }

      cacheRef.current.set(key, {
        data: result,
        timestamp: Date.now(),
      });
    } catch (err) {
      setError(err instanceof Error ? err : new Error(String(err)));
    } finally {
      setIsLoading(false);
    }
  }, [key, fetcher, maxSize]);

  useEffect(() => {
    const cached = cacheRef.current.get(key);
    if (cached && Date.now() - cached.timestamp < ttl) {
      setData(cached.data);
      return;
    }

    refetch();
  }, [key, ttl, refetch]);

  return { data, isLoading, error, refetch, clearCache };
}

// 请求 Hook（带取消功能）
export function useRequest<T>(
  requestFn: () => Promise<T>,
  options?: {
    immediate?: boolean;
    onSuccess?: (data: T) => void;
    onError?: (error: Error) => void;
  }
): {
  data: T | null;
  isLoading: boolean;
  error: Error | null;
  execute: () => Promise<void>;
  cancel: () => void;
} {
  const { immediate = true, onSuccess, onError } = options || {};
  const [data, setData] = useState<T | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  const abortControllerRef = useRef<AbortController | null>(null);

  const cancel = useCallback(() => {
    if (abortControllerRef.current) {
      abortControllerRef.current.abort();
      abortControllerRef.current = null;
    }
  }, []);

  const execute = useCallback(async () => {
    cancel();
    abortControllerRef.current = new AbortController();

    setIsLoading(true);
    setError(null);

    try {
      const result = await requestFn();
      setData(result);
      onSuccess?.(result);
    } catch (err) {
      if (err instanceof Error && err.name === 'AbortError') {
        return;
      }
      const error = err instanceof Error ? err : new Error(String(err));
      setError(error);
      onError?.(error);
    } finally {
      setIsLoading(false);
    }
  }, [requestFn, onSuccess, onError, cancel]);

  useEffect(() => {
    if (immediate) {
      execute();
    }
    return cancel;
  }, [immediate, execute, cancel]);

  return { data, isLoading, error, execute, cancel };
}

// 可视区域检测 Hook
export function useIntersectionObserver(
  options?: IntersectionObserverInit
): {
  ref: React.RefObject<HTMLDivElement>;
  isIntersecting: boolean;
  entry: IntersectionObserverEntry | null;
} {
  const [isIntersecting, setIsIntersecting] = useState(false);
  const [entry, setEntry] = useState<IntersectionObserverEntry | null>(null);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const element = ref.current;
    if (!element) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        setIsIntersecting(entry.isIntersecting);
        setEntry(entry);
      },
      options
    );

    observer.observe(element);

    return () => {
      observer.disconnect();
    };
  }, [options]);

  return { ref, isIntersecting, entry };
}

// 性能监控 Hook
export function usePerformanceMonitor(): {
  fps: number;
  memory: number;
  startTime: number;
  measureRender: (name: string) => void;
} {
  const [fps, setFps] = useState(60);
  const [memory, setMemory] = useState(0);
  const startTime = useRef(Date.now());
  const frameCount = useRef(0);
  const lastTime = useRef(Date.now());
  const renderMarks = useRef<Map<string, number>>(new Map());

  useEffect(() => {
    const measureFPS = () => {
      frameCount.current++;
      const now = Date.now();
      const elapsed = now - lastTime.current;

      if (elapsed >= 1000) {
        setFps(Math.round(frameCount.current * 1000 / elapsed));
        frameCount.current = 0;
        lastTime.current = now;
      }

      requestAnimationFrame(measureFPS);
    };

    requestAnimationFrame(measureFPS);

    // 内存监控（仅在支持的浏览器中）
    const measureMemory = () => {
      if (performance.memory) {
        setMemory(Math.round(performance.memory.usedJSHeapSize / 1024 / 1024));
      }
    };

    measureMemory();
    const interval = setInterval(measureMemory, 5000);

    return () => {
      clearInterval(interval);
    };
  }, []);

  const measureRender = useCallback((name: string) => {
    const start = performance.now();
    renderMarks.current.set(`${name}_start`, start);

    // 在下一帧测量渲染时间
    requestAnimationFrame(() => {
      const end = performance.now();
      const duration = end - start;
      console.log(`[Performance] ${name} render time: ${duration.toFixed(2)}ms`);
    });
  }, []);

  return {
    fps,
    memory,
    startTime: startTime.current,
    measureRender,
  };
}

// Memoized 过滤 Hook
export function useFilteredData<T>(
  data: T[],
  filterFn: (item: T) => boolean,
  deps: any[] = []
): T[] {
  return useMemo(() => {
    return data.filter(filterFn);
  }, [data, ...deps]);
}

// Memoized 排序 Hook
export function useSortedData<T>(
  data: T[],
  compareFn: (a: T, b: T) => number,
  deps: any[] = []
): T[] {
  return useMemo(() => {
    return [...data].sort(compareFn);
  }, [data, ...deps]);
}

// 批量更新 Hook
export function useBatchUpdate<T>(
  updates: T[],
  batchDelay: number = 100
): T[] {
  const [batchedUpdates, setBatchedUpdates] = useState<T[]>([]);
  const pendingUpdates = useRef<T[]>([]);
  const timeoutRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    pendingUpdates.current.push(...updates);

    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current);
    }

    timeoutRef.current = setTimeout(() => {
      setBatchedUpdates([...pendingUpdates.current]);
      pendingUpdates.current = [];
      timeoutRef.current = null;
    }, batchDelay);

    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, [updates, batchDelay]);

  return batchedUpdates;
}

export default {
  useDebounce,
  useThrottle,
  useLazyLoad,
  useInfiniteScroll,
  useCache,
  useRequest,
  useIntersectionObserver,
  usePerformanceMonitor,
  useFilteredData,
  useSortedData,
  useBatchUpdate,
};